part of todo_mvc_app;

class Header extends ui.VerticalPanel implements PastReactionApi {
  ui.Button _undo;
  ui.Button _redo;

  Header(TodoApp todoApp) {
    DomainSession session = todoApp.session;
    session.past.startPastReaction(this);
    Tasks tasks = todoApp.tasks;

    spacing = 16;

    var title = new ui.Label('Todos');
    title.getElement().id = 'title';
    add(title);

    var hPanel = new ui.HorizontalPanel();
    hPanel.spacing = 8;
    add(hPanel);

    _undo = new ui.Button(
        'Undo', new event.ClickHandlerAdapter((event.ClickEvent e) {
          session.past.undo();
        }));
    _undo.visible = false;
    _undo.getElement().classes.add('todo-button');
    hPanel.add(_undo);

    _redo = new ui.Button(
        'Redo', new event.ClickHandlerAdapter((event.ClickEvent e) {
          session.past.redo();
        }));
    _redo.visible = false;
    _redo.getElement().classes.add('todo-button');
    hPanel.add(_redo);

    var newTodo = new ui.TextBox();
    newTodo.setSize('648px', '24px');
    newTodo.addKeyPressHandler(new
        event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
          if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
            var title = newTodo.text.trim();
            if (title != '') {
              var task = new Task(tasks.concept);
              task.title = title;
              new AddAction(session, tasks, task).doit();
              newTodo.text = '';
            }
          }
        }));
    add(newTodo);
  }

  reactCannotUndo() {
    _undo.visible = false;
  }

  reactCanUndo() {
    _undo.visible = true;
  }

  reactCanRedo() {
    _redo.visible = true;
  }

  reactCannotRedo() {
    _redo.visible = false;
  }
}