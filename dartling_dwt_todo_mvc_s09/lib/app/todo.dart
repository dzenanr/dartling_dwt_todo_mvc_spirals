part of todo_mvc_app;

class Todo extends ui.Composite {
  Task task;

  ui.CheckBox _completed;
  ui.Label _todo;
  ui.Button _remove;
  ui.Grid _grid;

  Todo(TodoApp todoApp, this.task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;

    _grid = new ui.Grid(1, 3);
    _grid.setCellSpacing(8);
    _grid.addStyleName('todo');
    _grid.getRowFormatter().setVerticalAlign(
        0, i18n.HasVerticalAlignment.ALIGN_MIDDLE);
    initWidget(_grid);

    _completed = new ui.CheckBox();
    _completed.setValue(task.completed);
    _completed.addValueChangeHandler(new event.ValueChangeHandlerAdapter(
      (event.ValueChangeEvent e) {
        new SetAttributeAction(session, task, 'completed',
          !task.completed).doit();
      })
    );
    _grid.setWidget(0, 0, _completed);

    _todo = new ui.Label();
    _todo.text = task.title;
    _todo.addStyleName('todo');
    _todo.addDoubleClickHandler(
      new event.DoubleClickHandlerAdapter((event.DoubleClickEvent e) {
        _completed.visible = false;
        _remove.visible = false;
        var todo_retitle = new ui.TextBox();
        todo_retitle.text = _todo.text;
        todo_retitle.addStyleName('todo retitle');
        todo_retitle.addKeyPressHandler(new
          event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
            if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
              var newTitle = todo_retitle.text;
              var otherTask = tasks.firstWhereAttribute('title', newTitle);
              if (otherTask == null) {
                bool done = new SetAttributeAction(
                    session, task, 'title', newTitle).doit();
                if (!done) {
                  todo_retitle.text = '${task.title}';
                  tasks.errors.clear();
                }
              } else {
                _displayTodo();
              }
            } else if (e.getNativeKeyCode() == event.KeyCodes.KEY_ESCAPE) {
              _displayTodo();
            }
          })
        );
        _grid.setWidget(0, 1, todo_retitle);
      })
    );
    _grid.setWidget(0, 1, _todo);

    _remove = new ui.Button(
      'X', new event.ClickHandlerAdapter((event.ClickEvent e) {
        new RemoveAction(session, tasks, task).doit();
      })
    );
    _remove.addStyleName('todo-button remove');
    _grid.setWidget(0, 2, _remove);
  }

  complete(bool completed) {
    _completed.setValue(completed);
    if (completed) {
      _todo.addStyleName('completed');
    } else {
      _todo.removeStyleName('completed');
    }
  }

  _displayTodo() {
    _completed.visible = true;
    _remove.visible = true;
    _grid.setWidget(0, 1, _todo);
  }

  retitle(String title) {
    _todo.text = title;
    _displayTodo();
  }
}