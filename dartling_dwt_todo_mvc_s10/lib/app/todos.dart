part of todo_mvc_app;

/**
 * Composite shows Todo components.
 */
class Todos extends ui.Composite implements ActionReactionApi {
  TodoApp _todoApp;
  UnorderedList _todoList;

  /**
   * Create new instance of [Todos].
   */
  Todos(this._todoApp) {
    _todoList = new UnorderedList.wrap(query("#todo-list"));
    initWidget(_todoList);

    _todoApp.domain.startActionReaction(this);
    _load(_todoApp.tasks);
  }

  /**
   * Load list of task as JSON string, deserialize and create Todo components.
   */
  _load(Tasks tasks) {
    String json = window.localStorage['todos-dartling-dwt'];
    if (json != null) {
      try {
        tasks.fromJson(parse(json));
        for (Task task in tasks) {
          _add(task);
        }
      } on Exception catch(e) {
        print(e);
      }
    }
  }

  /**
   * Add [task] as Todo presentation.*/
  _add(Task task) {
    var todo = new Todo(_todoApp, task);
    todo.complete(task.completed);
    _todoList.addItem(todo);
  }

  /**
   * Find [task] between Todo components and return as Todo class instance.
   */
  Todo _find(Task task) {
    for (int i = 0; i < _todoList.getWidgetCount(); i++) {
      Todo todo = _todoList.getWidgetAt(i);
      if (todo.task == task) {
        return todo;
      }
    }
  }

  /**
   * Find Todo by [task] and mark it as completed.
   */
  _complete(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.complete(task.completed);
    }
  }

  /**
   * Find Todo and retitle based on [task.title].
   */
  _retitle(Task task) {
    var todo = _find(task);
    if (todo != null) {
      todo.retitle(task.title);
    }
  }

  /**
   * Find Todo by [task] and remove from list of components.
   */
  _remove(Task task) {
    var todo = _find(task);
    if (todo != null) {
      _todoList.remove(todo);
    }
  }

  /**
   * Display all Todo components.
   */
  displayAll() {
    for (int i = 0; i < _todoList.getWidgetCount(); i++) {
      Todo todo = _todoList.getWidgetAt(i);
      todo.visible = true;
    }
  }

  /**
   * Display only left Todos.
   */
  displayLeft() {
    for (int i = 0; i < _todoList.getWidgetCount(); i++) {
      Todo todo = _todoList.getWidgetAt(i);
      if (todo.task.left) {
        todo.visible = true;
      } else {
        todo.visible = false;
      }
    }
  }

  /**
   * Display only completed Todos.
   */
  displayCompleted() {
    for (int i = 0; i < _todoList.getWidgetCount(); i++) {
      Todo todo = _todoList.getWidgetAt(i);
      if (todo.task.completed) {
        todo.visible = true;
      } else {
        todo.visible = false;
      }
    }
  }

  /**
   * React by [action].
   */
  react(ActionApi action) {
    updateTodo(SetAttributeAction action) {
      if (action.property == 'completed') {
        _complete(action.entity);
      } else if (action.property == 'title') {
        _retitle(action.entity);
      }
    }

    if (action is Transaction) {
      for (var transactionAction in action.past.actions) {
        if (transactionAction is SetAttributeAction) {
          updateTodo(transactionAction);
        } else if (transactionAction is RemoveAction) {
          if (transactionAction.undone) {
            _add(transactionAction.entity);
          } else {
            _remove(transactionAction.entity);
          }
        } else if (transactionAction is AddAction) {
          if (transactionAction.undone) {
            _remove(transactionAction.entity);
          } else {
            _add(transactionAction.entity);
          }
        }
      }
    } else if (action is AddAction) {
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
      updateTodo(action);
    }
    _todoApp.updateDisplay();
    _todoApp.save();
  }
}


