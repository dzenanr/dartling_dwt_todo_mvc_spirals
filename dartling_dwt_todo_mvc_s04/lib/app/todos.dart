part of todo_mvc_app;

class Todos extends ui.VerticalPanel implements ActionReactionApi {
  TodoApp _todoApp;

  Todos(this._todoApp) {
    _todoApp.domain.startActionReaction(this);
    _load(_todoApp.tasks);

    addStyleName('todos');
  }

  _load(Tasks tasks) {
    String json = window.localStorage['tasks'];
    if (json != null) {
      tasks.fromJson(JSON.decode(json));
      for (Task task in tasks) {
        _add(task);
      }
    }
  }

  _add(Task task) {
    var todo = new Todo(_todoApp, task);
    add(todo);
  }

  Todo _find(Task task) {
    for (int i = 0; i < getWidgetCount(); i++) {
      Todo todo = getWidgetAt(i);
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
      remove(todo);
    }
  }

  react(ActionApi action) {
    if (action is AddAction) {
      if (action.undone) {
        _remove((action as AddAction).entity);
      } else {
        _add((action as AddAction).entity);
      }
    } else if (action is RemoveAction) {
      if (action.undone) {
        _add((action as RemoveAction).entity);
      } else {
        _remove((action as RemoveAction).entity);
      }
    } else if (action is SetAttributeAction) {
      _complete((action as SetAttributeAction).entity);
    }
    _todoApp.save();
  }
}


