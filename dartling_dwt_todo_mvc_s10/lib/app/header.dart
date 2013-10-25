part of todo_mvc_app;

/**
 * Header composite component
 */
class Header extends ui.Composite {
  Tasks _tasks;
  DomainSession _session;

  ui.SimpleCheckBox _completeAll;
  ui.HtmlPanel _header;
  ui.TextBox _newTodo;

	/**
	 * Create new instance of [Header].
	 */
  Header(TodoApp todoApp) {
    _session = todoApp.session;
    _tasks = todoApp.tasks;

    // Get #header from page
    _header = new ui.HtmlPanel.wrap(querySelector("#header"));
    initWidget(_header);

    // Get #toggle-all checkbox from page
    _completeAll = new ui.SimpleCheckBox.wrap(querySelector("#toggle-all"));
    updateDisplay();
    _completeAll.addClickHandler(new event.ClickHandlerAdapter(_completeAllHandler));
    _completeAll.addKeyPressHandler(new event.KeyPressHandlerAdapter(_completeAllHandler));

    // Get #new-todo imput from page
    _newTodo = new ui.TextBox.wrap(querySelector("#new-todo"));
    _newTodo.addKeyPressHandler(new
      event.KeyPressHandlerAdapter((event.KeyPressEvent e) {
        if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
          var task = new Task(_tasks.concept);
          task.title = _newTodo.text.trim();
          bool done = new AddAction(_session, _tasks, task).doit();
          if (done) {
            _newTodo.text = '';
          } else {
            var e = '';
            for (ValidationError ve in _tasks.errors) {
              e = '${ve.message} $e';
            }
            for (ValidationError ve in task.errors) {
              e = '${ve.message} $e';
            }
            _newTodo.text = '$e';
            _tasks.errors.clear();
            task.errors.clear();
          }
        } else if (e.getNativeKeyCode() == event.KeyCodes.KEY_ESCAPE) {
          _newTodo.text = '';
        }
      })
    );
  }

  /**
   * Update information in all corresponding elements on page.
   */
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

  /**
   * Toggel button click and key press handler.
   */
  void _completeAllHandler(event.DwtEvent evt) {
    if (_tasks.length > 0) {
      var transaction = new Transaction('complete-all', _session);
      if (_tasks.left.length == 0) {
        for (Task task in _tasks) {
          transaction.add(
              new SetAttributeAction(_session, task, 'completed', false));
        }
      } else {
        for (Task task in _tasks.left) {
          transaction.add(
              new SetAttributeAction(_session, task, 'completed', true));
        }
      }
      transaction.doit();
    }
  }
}