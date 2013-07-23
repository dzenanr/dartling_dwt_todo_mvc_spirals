part of todo_mvc_app;

class Footer extends ui.Composite {
  Tasks _tasks;

  Todos _todos;
  ui.InlineHtml _leftCount;
  ui.ListBox _selection;
  ui.Button _clearCompleted;

  Footer(TodoApp todoApp, this._todos) {
    DomainSession session = todoApp.session;
    _tasks = todoApp.tasks;

    ui.Grid grid = new ui.Grid(1, 3);
    grid.setCellPadding(2);
    grid.addStyleName('footer');
    grid.getRowFormatter().setVerticalAlign(
      0, i18n.HasVerticalAlignment.ALIGN_MIDDLE);
    initWidget(grid);

    grid.addStyleName('footer');

    _leftCount = new ui.InlineHtml();
    grid.setWidget(0, 0, _leftCount);

    _selection = new ui.ListBox();
    _selection.addItem('All');
    _selection.addItem('Active');
    _selection.addItem('Completed');
    _selection.addChangeHandler(new event.ChangeHandlerAdapter(
      (event.ChangeEvent event) {
        _updateSelectionDisplay();
      })
    );
    _selection.addStyleName('selection-list-box');
    grid.setWidget(0, 1, _selection);

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
    _clearCompleted.addStyleName('todo-button');
    grid.setWidget(0, 2, _clearCompleted);
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
      _leftCount.html = '<strong>${leftLength}</strong> todo${leftLength != 1 ? 's' : ''} left';

      _updateSelectionDisplay();

      if (completedLength == 0) {
        _clearCompleted.visible = false;
      } else {
        _clearCompleted.visible = true;
      }
      _clearCompleted.text = 'Clear completed (${completedLength})';
    } else {
      visible = false;
    }
  }
}

