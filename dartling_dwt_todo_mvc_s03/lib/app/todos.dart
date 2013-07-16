part of todo_mvc_app;

class Todos extends ui.VerticalPanel implements ActionReactionApi {
  TodoApp _todoApp;
  Tasks _tasks;

  var _listPanel = new ui.VerticalPanel();

  Todos(this._todoApp) {
    _todoApp.domain.startActionReaction(this);
    DomainSession session = _todoApp.session;
    _tasks = _todoApp.tasks;

    spacing = 10;
    var newTodo = new ui.TextBox();
    newTodo.addKeyPressHandler(new
        event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
          if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
            var title = newTodo.text.trim();
            if (title != '') {
              var task = new Task(_tasks.concept);
              task.title = title;
              new AddAction(session, _tasks, task).doit();
              newTodo.text = '';
            }
          }
        }));
    add(newTodo);

    _listPanel.spacing = 4;
    add(_listPanel);

    _load();
  }

  _load() {
    String json = window.localStorage['tasks'];
    if (json != null) {
      _tasks.fromJson(parse(json));
      for (Task task in _tasks) {
        _add(task);
      }
    }
  }

  _add(Task task) {
    var todo = new ui.Label(task.title);
    _listPanel.add(todo);
  }

  /*
  _remove(Task task) {
    ui.WidgetCollection widgets = _listPanel.getChildren();
    for (var widget in widgets) {
      if (widget.text == task.title) {
        widgets.removeWidget(widget);
      }
    }
  }
  */

  _remove(Task task) {
    _listPanel.clear();
    for (var task in _tasks) {
      _add(task);
    }
  }

  react(ActionApi action) {
    if (action is AddAction) {
      if (action.undone) {
        _remove(action.entity);
      } else {
        _add(action.entity);
      }
    } else if (action is RemoveAction) {
      if (action.undone) {
        _add(action.entity);
      } else {
        _remove(action.entity);
      }
    }

    // to delete after debuging _remove
    print('');
    print('---');
    for (var task in _tasks) {
      print(task.title);
    }
    print('---');
    print('');
    // to delete after debuging _remove

    _todoApp.save();
  }
}


