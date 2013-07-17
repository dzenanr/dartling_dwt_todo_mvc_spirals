part of todo_mvc_app;

class Todo extends ui.HorizontalPanel {
  ui.CheckBox _completed;
  ui.Label _todo;

  Todo(TodoApp todoApp, Task _task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;

    spacing = 8;

    _completed = new ui.CheckBox();
    _completed.setValue(_task.completed);
    add(_completed);
    _completed.addValueChangeHandler(new event.ValueChangeHandlerAdapter(
        (event.ValueChangeEvent e) {
          new SetAttributeAction(session, _task, 'completed',
              !_task.completed).doit();
        }));

    var sPanel = new ui.SimplePanel();
    sPanel.setSize('600px', '8px');
    add(sPanel);
    _todo = new ui.Label(_task.title);
    sPanel.add(_todo);

    ui.Button remove = new ui.Button(
        'X', new event.ClickHandlerAdapter((event.ClickEvent e) {
          new RemoveAction(session, tasks, _task).doit();
        }));
    remove.getElement().classes.add('todo-button');
    add(remove);
  }

  String get title => _todo.text;

  complete(bool completed) {
    _completed.setValue(completed);
  }
}