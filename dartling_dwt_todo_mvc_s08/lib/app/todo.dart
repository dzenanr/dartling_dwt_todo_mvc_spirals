part of todo_mvc_app;

class Todo extends ui.HorizontalPanel {
  Task task;

  ui.CheckBox _completed;
  ui.TextBox _todo;

  Todo(TodoApp todoApp, this.task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;

    spacing = 8;

    _completed = new ui.CheckBox();
    _completed.setValue(task.completed);
    _completed.addValueChangeHandler(new event.ValueChangeHandlerAdapter(
      (event.ValueChangeEvent e) {
        new SetAttributeAction(session, task, 'completed',
            !task.completed).doit();
      })
    );
    add(_completed);

    _todo = new ui.TextBox();
    _todo.text = task.title;
    _todo.setSize('560px', '16px');
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
    add(_todo);

    ui.Button remove = new ui.Button(
      'x', new event.ClickHandlerAdapter((event.ClickEvent e) {
        new RemoveAction(session, tasks, task).doit();
      })
    );
    remove.getElement().classes.add('todo-button');
    add(remove);
  }

  complete(bool completed) {
    _completed.setValue(completed);
  }
}