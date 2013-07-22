part of todo_mvc_app;

class Footer extends ui.HorizontalPanel {
  Tasks _tasks;

  ui.Label _leftCount;
  ui.Button _clearCompleted;

  Footer(TodoApp todoApp) {
    DomainSession session = todoApp.session;
    _tasks = todoApp.tasks;

    addStyleName('footer');

    _leftCount = new ui.Label();
    add(_leftCount);

    _clearCompleted = new ui.Button(
        'Clear completed', new event.ClickHandlerAdapter((event.ClickEvent e) {
          var transaction = new Transaction('clear-completed', session);
          for (Task task in _tasks.completed) {
            transaction.add(
                new RemoveAction(session, _tasks.completed, task));
          }
          transaction.doit();
        }));
    _clearCompleted.addStyleName('todo-button');
    add(_clearCompleted);
  }

  updateDisplay() {
    var completedLength = _tasks.completed.length;
    var leftLength = _tasks.left.length;
    if (leftLength > 0) {
      _leftCount.visible = true;
      _leftCount.text = '${leftLength} todo${leftLength != 1 ? 's' : ''} left';
    } else {
      _leftCount.visible = false;
    }
    if (completedLength == 0) {
      _clearCompleted.visible = false;
    } else {
      _clearCompleted.visible = true;
      _clearCompleted.text = 'Clear completed (${completedLength})';
    }
  }
}

