part of todo_mvc_app;

class Todo extends ui.HorizontalPanel {
  ui.CheckBox _completed;
  ui.Label _todo;

  Todo(TodoApp todoApp,Task task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;

    spacing = 8;

    _completed = new ui.CheckBox();
    _completed.setValue(task.completed);
    add(_completed);
    _completed.addValueChangeHandler(new event.ValueChangeHandlerAdapter(
        (event.ValueChangeEvent e) {
          new SetAttributeAction(session, task, 'completed',
              !task.completed).doit();
        }));

    _todo = new ui.Label(task.title);
    _todo.addStyleName('todo');
    add(_todo);

    ui.Button remove = new ui.Button(
        'X', new event.ClickHandlerAdapter((event.ClickEvent e) {
          new RemoveAction(session, tasks, task).doit();
        }));
    remove.addStyleName('todo-button');
    add(remove);
  }

  String get title => _todo.text;

  complete(bool completed) {
    _completed.setValue(completed);
  }
}