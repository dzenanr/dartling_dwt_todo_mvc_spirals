part of todo_mvc_app;

class Todo extends ui.HorizontalPanel {
  Task _task;

  ui.CheckBox _completed;
  ui.Label _todo;
  ui.Button _remove;

  Todo(TodoApp todoApp, this._task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;

    spacing = 16;

    _completed = new ui.CheckBox();
    _completed.setValue(_task.completed);
    add(_completed);
    _completed.addValueChangeHandler(new event.ValueChangeHandlerAdapter(
        (event.ValueChangeEvent e) {
          new SetAttributeAction(session, _task, 'completed',
              !_task.completed).doit();
        }));

    var sPanel = new ui.SimplePanel();
    sPanel.setSize('540px', '8px');
    add(sPanel);
    _todo = new ui.Label(_task.title);
    sPanel.add(_todo);

    _remove = new ui.Button(
        'x', new event.ClickHandlerAdapter((event.ClickEvent e) {
          new RemoveAction(session, tasks, _task).doit();
        }));
    add(_remove);
  }

  String get title => _todo.text;

  complete(bool completed) {
    _completed.setValue(completed);
  }
}