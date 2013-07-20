part of todo_mvc_app;

class Footer extends ui.HorizontalPanel {
  Tasks _tasks;

  Todos _todos;
  ui.Label _leftCount;
  ui.ListBox _selection;
  ui.Button _clearCompleted;

  Footer(TodoApp todoApp, this._todos) {
    DomainSession session = todoApp.session;
    _tasks = todoApp.tasks;

    setSize('656px', '16px');
    getElement().id = 'footer';

    _leftCount = new ui.Label();
    add(_leftCount);

    _selection = new ui.ListBox();
    _selection.addItem('all');
    _selection.addItem('left');
    _selection.addItem('completed');
    _selection.addChangeHandler(new event.ChangeHandlerAdapter((event.ChangeEvent event) {
      _updateSelectionDisplay();
    }));
    _selection.getElement().classes.add('selection-list-box');
    add(_selection);

    _clearCompleted = new ui.Button(
      'Clear completed', new event.ClickHandlerAdapter((event.ClickEvent e) {
        var transaction = new Transaction('clear-completed', session);
        for (Task task in _tasks.completed) {
          transaction.add(
              new RemoveAction(session, _tasks.completed, task));
        }
        transaction.doit();
      })
    );
    _clearCompleted.getElement().classes.add('todo-button');
    _clearCompleted.getElement().classes.add('disabled-todo-button');
    add(_clearCompleted);
  }

  _updateSelectionDisplay() {
    int index = _selection.getSelectedIndex();
    if (index == 0) {
      _todos.displayAll();
    } else if (index == 1) {
      _todos.displayLeft();
    } else if (index == 2) {
      _todos.displayCompleted();
    }
  }

  updateDisplay() {
    var allLength = _tasks.length;
    if (allLength > 0) {
      visible = true;
      var completedLength = _tasks.completed.length;
      var leftLength = _tasks.left.length;
      _leftCount.text = '${leftLength} todo${leftLength != 1 ? 's' : ''} left';

      _updateSelectionDisplay();

      if (completedLength == 0) {
        _clearCompleted.getElement().classes.add('disabled-todo-button');
      } else {
        _clearCompleted.getElement().classes.remove('disabled-todo-button');
      }
      _clearCompleted.text = 'clear completed (${completedLength})';
    } else {
      visible = false;
    }
  }
}

