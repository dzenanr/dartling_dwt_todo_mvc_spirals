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

    var appTitle = new ui.Label('Todos');
    appTitle.getElement().id = 'app-title';
    add(appTitle);

    var linkPanel = new ui.HorizontalPanel();
    linkPanel.spacing = 8;
    add(linkPanel);

    var dartling = new ui.InlineHtml(
        '<a href="https://github.com/dzenanr/dartling">dartling</a>');
    linkPanel.add(dartling);

    var dwt = new ui.InlineHtml('<a href="http://dartwebtoolkit.com/">DWT</a>');
    linkPanel.add(dwt);

    var todoMvc = new ui.InlineHtml(
        '<a href="http://todomvc.com/">Todo MVC</a>');
    linkPanel.add(todoMvc);

    var actionPanel = new ui.HorizontalPanel();
    actionPanel.spacing = 8;
    add(actionPanel);

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
      })
    );
    actionPanel.add(_completeAll);

    _undo = new ui.Button(
      'Undo', new event.ClickHandlerAdapter((event.ClickEvent e) {
        session.past.undo();
      })
    );
    _undo.enabled = false;
    _undo.getElement().classes.add('todo-button');
    _undo.getElement().classes.add('disabled-todo-button');
    actionPanel.add(_undo);

    _redo = new ui.Button(
      'Redo', new event.ClickHandlerAdapter((event.ClickEvent e) {
        session.past.redo();
      })
    );
    _redo.enabled = false;
    _redo.getElement().classes.add('todo-button');
    _undo.getElement().classes.add('disabled-todo-button');
    actionPanel.add(_redo);

    var newTodoPanel = new ui.HorizontalPanel();
    newTodoPanel.spacing = 12;
    add(newTodoPanel);

    var newTodo = new ui.TextBox();
    newTodo.setSize('560px', '16px');
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
      })
    );
    newTodoPanel.add(newTodo);

    var cancelNewTodo = new ui.Button(
      'Cancel', new event.ClickHandlerAdapter((event.ClickEvent e) {
        newTodo.text = '';
      })
    );
    cancelNewTodo.getElement().classes.add('todo-button');
    newTodoPanel.add(cancelNewTodo);
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
    _undo.getElement().classes.add('disabled-todo-button');
  }

  reactCanUndo() {
    _undo.enabled = true;
    _undo.getElement().classes.remove('disabled-todo-button');
  }

  reactCanRedo() {
    _redo.enabled = true;
    _redo.getElement().classes.remove('disabled-todo-button');
  }

  reactCannotRedo() {
    _redo.enabled = false;
    _redo.getElement().classes.add('disabled-todo-button');
  }
}