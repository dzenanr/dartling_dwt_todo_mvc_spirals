part of todo_mvc_app;

class Todo extends ui.Composite {
  Task task;

  ui.CheckBox _completed;
  ui.Label _todo;
  ui.Button _remove;
  ui.TextBox _todo_retitle;

  Todo(TodoApp todoApp, this.task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;

    ui.Grid grid = new ui.Grid(1, 3);
    grid.setCellSpacing(8);
    grid.addStyleName('todo');
    grid.getRowFormatter().setVerticalAlign(
        0, i18n.HasVerticalAlignment.ALIGN_MIDDLE);
    initWidget(grid);

    _completed = new ui.CheckBox();
    _completed.setValue(task.completed);
    _completed.addValueChangeHandler(new event.ValueChangeHandlerAdapter(
      (event.ValueChangeEvent e) {
        new SetAttributeAction(session, task, 'completed',
          !task.completed).doit();
      })
    );
    grid.setWidget(0, 0, _completed);

    _todo = new ui.Label();
    _todo.text = task.title;
    _todo.addStyleName('todo');
    _todo.addDoubleClickHandler(
      new event.DoubleClickHandlerAdapter((event.DoubleClickEvent e) {
        _completed.visible = false;
        _todo.visible = false;
        _remove.visible = false;
        _todo_retitle = new ui.TextBox();
        _todo_retitle.text = _todo.text;
        _todo_retitle.addStyleName('todo retitle');
        _todo_retitle.addKeyPressHandler(new
          event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
            if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
              var newTitle = _todo_retitle.text.trim();
              if (newTitle != '') {
                var removeAction = new RemoveAction(session, tasks, task);
                var newTaskWithNewTitle =
                  new Task.withId(task.concept, newTitle);
                var addAction =
                  new AddAction(session, tasks, newTaskWithNewTitle);
                var transaction = new Transaction('update title', session);
                transaction.add(removeAction);
                transaction.add(addAction);
                // The id can be updated by removing and adding a task.
                bool done = transaction.doit();
                if (!done) {
                  _todo_retitle.text = '${task.title}';
                  tasks.errors.clear();
                }
              }
            } else if (e.getNativeKeyCode() == event.KeyCodes.KEY_ESCAPE) {
              // ?
            }
          })
        );
        grid.setWidget(0, 1, _todo_retitle);
      })
    );
    grid.setWidget(0, 1, _todo);

    _remove = new ui.Button(
      'X', new event.ClickHandlerAdapter((event.ClickEvent e) {
        new RemoveAction(session, tasks, task).doit();
      })
    );
    _remove.addStyleName('todo-button remove');
    grid.setWidget(0, 2, _remove);
  }

  complete(bool completed) {
    _completed.setValue(completed);
    if (completed) {
      _todo.addStyleName('completed');
    } else {
      _todo.removeStyleName('completed');
    }
  }
}