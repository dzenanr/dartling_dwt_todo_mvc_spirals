part of todo_mvc_app;

class Header extends ui.VerticalPanel implements PastReactionApi {
  Tasks _tasks;

  ui.CheckBox _completeAll;
  ui.Button _undo;
  ui.Button _redo;

  Header(TodoApp todoApp) {
    DomainSession session = todoApp.session;
    session.past.startPastReaction(this);
    _tasks = todoApp.tasks;

    spacing = 16;

    var appTitle = new ui.Label('Todos');
    appTitle.addStyleName('app-title');
    add(appTitle);

    var hPanel = new ui.HorizontalPanel();
    hPanel.spacing = 8;
    add(hPanel);

    _completeAll = new ui.CheckBox();
    updateDisplay();
    _completeAll.addValueChangeHandler(new event.ValueChangeHandlerAdapter(
        (event.ValueChangeEvent e) {
          var transaction = new Transaction('complete-all', session);
          if (_tasks.left.length == 0) {
            for (Task task in _tasks) {
              transaction.add(
                  new SetAttributeAction(session, task, 'completed', false));
            }
          } else {
            for (Task task in _tasks.left) {
              transaction.add(
                  new SetAttributeAction(session, task, 'completed', true));
            }
          }
          transaction.doit();
        }));
    hPanel.add(_completeAll);

    _undo = new ui.Button(
        'Undo', new event.ClickHandlerAdapter((event.ClickEvent e) {
          session.past.undo();
        }));
    _undo.enabled = false;
    _undo.addStyleName('todo-button disabled-todo-button');
    hPanel.add(_undo);

    _redo = new ui.Button(
        'Redo', new event.ClickHandlerAdapter((event.ClickEvent e) {
          session.past.redo();
        }));
    _redo.enabled = false;
    _redo.addStyleName('todo-button disabled-todo-button');
    hPanel.add(_redo);

    var newTodo = new ui.TextBox();
    newTodo.addStyleName('todo-input');
    newTodo.addKeyPressHandler(new
        event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
          if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
            var title = newTodo.text.trim();
            if (title != '') {
              var task = new Task(_tasks.concept);
              task.title = title;
              bool done = new AddAction(session, _tasks, task).doit();
              if (done) {
                newTodo.text = '';
              } else {
                var e = '';
                for (ValidationError ve in _tasks.errors) {
                  e = '${ve.message} $e';
                }
                newTodo.text = '$e';
                _tasks.errors.clear();
              }
            }
          }
        }));
    add(newTodo);
  }

  updateDisplay() {
    var allLength = _tasks.length;
    var completedLength = _tasks.completed.length;
    if (allLength > 0 && allLength == completedLength) {
      _completeAll.setValue(true);
    } else {
      _completeAll.setValue(false);
    }
  }

  reactCannotUndo() {
    _undo.enabled = false;
    _undo.addStyleName('disabled-todo-button');
  }

  reactCanUndo() {
    _undo.enabled = true;
    _undo.removeStyleName('disabled-todo-button');
  }

  reactCanRedo() {
    _redo.enabled = true;
    _redo.removeStyleName('disabled-todo-button');
  }

  reactCannotRedo() {
    _redo.enabled = false;
    _redo.addStyleName('disabled-todo-button');
  }
}