part of todo_mvc_app;

/**
 * Footer composite component.
 */
class Footer extends ui.Composite {
  Tasks _tasks;

  Todos _todos;
  ui.HtmlPanel _footer;
  ui.InlineHtml _leftCount;
  ui.ListBox _selection;
  ui.Button _clearCompleted;

  /**
   * Create new instance of [Footer] component.
   */
  Footer(TodoApp todoApp, this._todos) {
    DomainSession session = todoApp.session;
    _tasks = todoApp.tasks;

    // Get #footer from page
    _footer = new ui.HtmlPanel.wrap(querySelector("#footer"));
    initWidget(_footer);

    // Get #todo-count from page
    _leftCount = new ui.InlineHtml.wrap(querySelector("#todo-count"));

    // Get #clear-completed from page
    _clearCompleted = new ui.Button.wrap(querySelector("#clear-completed"));
    _clearCompleted.addClickHandler(new event.ClickHandlerAdapter((event.ClickEvent e) {
        var transaction = new Transaction('clear-completed', session);
        for (Task task in _tasks.completed) {
          transaction.add(
            new RemoveAction(session, _tasks.completed, task));
        }
        transaction.doit();
      }));

    // Add History event handler
    ui.History.addValueChangeHandler(new event.ValueChangeHandlerAdapter((event.ValueChangeEvent evt){
      _updateSelectionDisplay();
    }));
  }

  /**
   * Update selection display base on [History] token information.
   */
  _updateSelectionDisplay() {
    String token = ui.History.getToken();
    if (token == "/active") {
      _todos.displayLeft();
      _selectNavigation(token);
    } else if (token == "/completed") {
      _todos.displayCompleted();
      _selectNavigation(token);
    } else {
      _todos.displayAll();
      _selectNavigation("/");
    }
  }

  /**
   * Select active navigation element based on [token].
   */
  void _selectNavigation(String token) {
    List<AnchorElement> anchors = querySelectorAll("#filters li a");
    if (anchors != null) {
      anchors.forEach((AnchorElement anchor){
        ui.Anchor a = new ui.Anchor.wrap(anchor);
        if (a.href.endsWith(token)) {
          a.addStyleName("selected");
        } else {
          a.removeStyleName("selected");
        }
      });
    }
  }

  /**
   * Update information in all corresponding elements on page.
   */
  updateDisplay() {
    var allLength = _tasks.length;
    if (allLength > 0) {
      _footer.visible = true;
      var completedLength = _tasks.completed.length;
      var leftLength = _tasks.left.length;
      _leftCount.html = '<strong>${leftLength}</strong> item${leftLength != 1 ? 's' : ''} left';

      _updateSelectionDisplay();

      if (completedLength == 0) {
        _clearCompleted.visible = false;
      } else {
        _clearCompleted.visible = true;
      }
      _clearCompleted.text = 'Clear completed (${completedLength})';
    } else {
      _footer.visible = false;
    }
  }
}

