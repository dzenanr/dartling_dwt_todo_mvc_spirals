part of todo_mvc_app;

class Todo extends ui.Composite {
  Task task;

  ui.CheckBox _completed;
  ui.TextBox _todo;

  Todo(TodoApp todoApp, this.task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;

    ui.Grid grid = new ui.Grid(1, 3);
    grid.setCellSpacing(8);
    grid.addStyleName('todo');
    grid.getRowFormatter().setVerticalAlign(0, i18n.HasVerticalAlignment.ALIGN_MIDDLE);
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

    _todo = new ui.TextBox();
    _todo.text = task.title;
    _todo.addStyleName('todo-input');
    _todo.addKeyPressHandler(new
      event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
        if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
          var newTitle = _todo.text.trim();
          if (newTitle != '') {
            var removeAction = new RemoveAction(session, tasks, task);
            var newTaskWithNewTitle = new Task.withId(task.concept, newTitle);
            var addAction = new AddAction(session, tasks, newTaskWithNewTitle);
            var transaction = new Transaction('update title', session);
            transaction.add(removeAction);
            transaction.add(addAction);
            // The id can be updated by removing and adding a task.
            bool done = transaction.doit();
            if (!done) {
              _todo.text = '${task.title}';
              tasks.errors.clear();
            }
          }
        }
      })
    );
    grid.setWidget(0, 1, _todo);

    ui.Button remove = new ui.Button(
      'x', new event.ClickHandlerAdapter((event.ClickEvent e) {
        new RemoveAction(session, tasks, task).doit();
      })
    );
    remove.addStyleName('todo-button');
    grid.setWidget(0, 2, remove);
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