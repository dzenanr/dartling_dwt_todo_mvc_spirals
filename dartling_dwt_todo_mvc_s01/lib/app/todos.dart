part of todo_mvc_app;

class Todos extends ui.VerticalPanel {
  var _listPanel = new ui.VerticalPanel();

  Todos(Tasks tasks) {
    spacing = 10;
    var newTodo = new ui.TextBox();
    newTodo.addKeyPressHandler(new
        event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
          if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
            var title = newTodo.text.trim();
            if (title != '') {
              var task = new Task(tasks.concept);
              task.title = title;
              tasks.add(task);
              _add(task);
              newTodo.text = '';
            }
          }
        }));
    add(newTodo);

    _listPanel.spacing = 4;
    add(_listPanel);
    /*
    for (var task in tasks) {
      _add(task);
    }
    */
  }

  _add(Task task) {
    var title = new ui.Label(task.title);
    _listPanel.add(title);
  }
}


