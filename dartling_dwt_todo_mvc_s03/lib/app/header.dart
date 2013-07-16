part of todo_mvc_app;

class Header extends ui.HorizontalPanel implements PastReactionApi {
  ui.Button _undo;
  ui.Button _redo;

  Header(TodoApp todoApp) {
    DomainSession session = todoApp.session;
    session.past.startPastReaction(this);

    spacing = 8;

    _undo = new ui.Button(
        'undo', new event.ClickHandlerAdapter((event.ClickEvent e) {
          session.past.undo();
        }));
    _undo.visible = false; // enabled does not work properly
    add(_undo);
    _redo = new ui.Button(
        'redo', new event.ClickHandlerAdapter((event.ClickEvent e) {
          session.past.redo();
        }));
    _redo.visible = false;
    add(_redo);
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