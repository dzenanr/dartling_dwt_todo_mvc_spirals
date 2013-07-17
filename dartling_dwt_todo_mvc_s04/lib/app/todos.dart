part of todo_mvc_app;

class Todos extends ui.VerticalPanel implements ActionReactionApi {
  TodoApp _todoApp;
  Tasks _tasks;

  var _listPanel = new ui.VerticalPanel();

  Todos(this._todoApp) {
    _todoApp.domain.startActionReaction(this);
    DomainSession session = _todoApp.session;
    _tasks = _todoApp.tasks;

    var newTodo = new ui.TextBox();
    newTodo.setSize('640px', '16px');
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
    var todo = new Todo(_todoApp, task);
    _listPanel.add(todo);
  }

  Todo _find(Task task) {
    for (int i = 0; i < _listPanel.getWidgetCount(); i++) {
      Todo todo = _listPanel.getWidgetAt(i);
      if (todo.title == task.title) {
        return todo;
      }
    }
  }

  _complete(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.complete(task.completed);
    }
  }

  _remove(Task task) {
    var todo = _find(task);
    if (todo != null) {
      _listPanel.remove(todo);
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
    } else if (action is SetAttributeAction) {
      _complete(action.entity);
    }
    _todoApp.save();
  }
}


