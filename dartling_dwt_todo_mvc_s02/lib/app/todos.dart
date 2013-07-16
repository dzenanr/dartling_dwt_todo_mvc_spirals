part of todo_mvc_app;

class Todos extends ui.VerticalPanel implements ActionReactionApi {
  TodoApp _todoApp;

  var _listPanel = new ui.VerticalPanel();

  Todos(this._todoApp) {
    _todoApp.domain.startActionReaction(this);
    DomainSession session = _todoApp.session;
    Tasks tasks = _todoApp.tasks;

    spacing = 10;
    var newTodo = new ui.TextBox();
    newTodo.addKeyPressHandler(new
        event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
          if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
            var title = newTodo.text.trim();
            if (title != '') {
              var task = new Task(tasks.concept);
              task.title = title;
              new AddAction(session, tasks, task).doit();
              newTodo.text = '';
            }
          }
        }));
    add(newTodo);

    _listPanel.spacing = 4;
    add(_listPanel);

    //load tasks
    String json = window.localStorage['todos'];
    if (json != null) {
      tasks.fromJson(parse(json));
      for (Task task in tasks) {
        _add(task);
      }
    }
  }

  _add(Task task) {
    var title = new ui.Label(task.title);
    _listPanel.add(title);
  }

  react(ActionApi action) {
    if (action is AddAction) {
      _add(action.entity);
    }
    _todoApp.save();
  }
}


