part of todo_mvc_app;

class Header extends ui.VerticalPanel implements PastReactionApi {
  Tasks _tasks;

  ui.CheckBox _completeAll;
  ui.Button _undo;
  ui.Button _redo;
  ui.Button _cancelNewTodo;

  Header(TodoApp todoApp) {
    DomainSession session = todoApp.session;
    session.past.startPastReaction(this);
    _tasks = todoApp.tasks;

    spacing = 16;

    var appTitle = new ui.Label('todos');
    appTitle.addStyleName('app-title');
    add(appTitle);

    var actionPanel = new ui.HorizontalPanel();
    actionPanel.spacing = 8;
    add(actionPanel);

    _completeAll = new ui.CheckBox();
    updateDisplay();
    _completeAll.addValueChangeHandler(new event.ValueChangeHandlerAdapter(
      (event.ValueChangeEvent e) {
        if (_tasks.length > 0) {
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
        }
      })
    );
    actionPanel.add(_completeAll);

    _undo = new ui.Button(
      'Undo', new event.ClickHandlerAdapter((event.ClickEvent e) {
        session.past.undo();
      })
    );
    _undo.enabled = false;
    _undo.addStyleName('todo-button disabled');
    actionPanel.add(_undo);

    _redo = new ui.Button(
      'Redo', new event.ClickHandlerAdapter((event.ClickEvent e) {
        session.past.redo();
      })
    );
    _redo.enabled = false;
    _redo.addStyleName('todo-button disabled');
    actionPanel.add(_redo);

    ui.Grid newTodoPanel = new ui.Grid(1, 2);
    newTodoPanel.setCellSpacing(12);
    newTodoPanel.getRowFormatter().setVerticalAlign(
      0, i18n.HasVerticalAlignment.ALIGN_MIDDLE);
    add(newTodoPanel);

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
              _cancelNewTodo.enabled = false;
              _cancelNewTodo.addStyleName('disabled');
            } else {
              var e = '';
              for (ValidationError ve in _tasks.errors) {
                e = '${ve.message} $e';
              }
              newTodo.text = '$e';
              _tasks.errors.clear();
            }
          }
        } else if (e.getNativeKeyCode() == event.KeyCodes.KEY_ESCAPE) {
          newTodo.text = '';
        } else {
          _cancelNewTodo.enabled = true;
          _cancelNewTodo.removeStyleName('disabled');
        }
      })
    );
    newTodoPanel.setWidget(0, 0, newTodo);

    _cancelNewTodo = new ui.Button(
      'Clear', new event.ClickHandlerAdapter((event.ClickEvent e) {
        newTodo.text = '';
        _cancelNewTodo.addStyleName('disabled');
        _cancelNewTodo.enabled = false;
      })
    );
    _cancelNewTodo.enabled = false;
    _cancelNewTodo.addStyleName('todo-button disabled');
    newTodoPanel.setWidget(0, 1, _cancelNewTodo);
  }

  updateDisplay() {
    var allLength = _tasks.length;
    if (allLength > 0) {
      _completeAll.enabled = true;
      var completedLength = _tasks.completed.length;
      if (allLength > 0 && allLength == completedLength) {
        _completeAll.setValue(true);
      } else {
        _completeAll.setValue(false);
      }
    } else {
      _completeAll.setValue(false);
      _completeAll.enabled = false;
    }
  }

  reactCannotUndo() {
    _undo.enabled = false;
    _undo.addStyleName('disabled');
  }

  reactCanUndo() {
    _undo.enabled = true;
    _undo.removeStyleName('disabled');
  }

  reactCanRedo() {
    _redo.enabled = true;
    _redo.removeStyleName('disabled');
  }

  reactCannotRedo() {
    _redo.enabled = false;
    _redo.addStyleName('disabled');
  }
}