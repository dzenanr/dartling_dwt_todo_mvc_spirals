part of todo_mvc_app;

/**
 * Todo composite component.
 */
class Todo extends ui.Composite {
  Task task;

  ListItem _li;
  ui.FlowPanel _view;
  CheckBox _completed;
  Label _todo;
  ui.Button _remove;
  ui.TextBox _edit;
  ui.Grid _grid;

  /**
   * Create an instance of [Todo].
   */
  Todo(TodoApp todoApp, this.task) {
    DomainSession session = todoApp.session;
    Tasks tasks = todoApp.tasks;

    // Create new LI element
    _li = new ListItem();
    initWidget(_li);
    
    // FlowPanel based on DIV element
    _view = new ui.FlowPanel();
    _view.addStyleName("view");
    _li.addContent(_view);
    
    // Completed CheckBox 
    _completed = new CheckBox(new CheckboxInputElement());
    _completed.addStyleName("toggle");
    _completed.setValue(task.completed);
    _completed.addValueChangeHandler(new event.ValueChangeHandlerAdapter((event.ValueChangeEvent e) {
        new SetAttributeAction(session, task, 'completed', !task.completed).doit();
      })
    );
    //
    _view.add(_completed);
    // Mark it attached and remember it for cleanup.
    _attachToRootPanel(_completed);
    
    // ToDo label 
    _todo = new Label();
    _todo.text = task.title;
    _todo.addDoubleClickHandler(new event.DoubleClickHandlerAdapter((event.DoubleClickEvent e) {
      _li.addStyleName("editing");
      _edit.focus = true;
    }));
    _view.add(_todo);
    // Mark it attached and remember it for cleanup.
    _attachToRootPanel(_todo);
    
    // Remove button
    _remove = new ui.Button();
    _remove.addStyleName("destroy");
    _remove.addClickHandler(new event.ClickHandlerAdapter((event.ClickEvent e) {
        new RemoveAction(session, tasks, task).doit();
     }));
    _view.add(_remove);
    // Mark it attached and remember it for cleanup.
    _attachToRootPanel(_remove);
    
    // Edit TextBox
    _edit = new ui.TextBox();
    _edit.addStyleName("edit");
    _edit.setValue(task.title);
    _edit.addKeyDownHandler(new
      event.KeyDownHandlerAdapter((event.KeyDownEvent e) {
        if (e.getNativeKeyCode() == event.KeyCodes.KEY_ENTER) {
          _updateTodo(session, tasks);
        } else if (e.getNativeKeyCode() == event.KeyCodes.KEY_ESCAPE) {
          _displayTodo();
        }
      })
    );
    _edit.addBlurHandler(new event.BlurHandlerAdapter((event.BlurEvent evt){
      _updateTodo(session, tasks);
    }));
    _li.addContent(_edit);
    // Mark it attached and remember it for cleanup.
    _attachToRootPanel(_edit);
  }

  /**
   * Create or Update new Todo content.
   */
  void _updateTodo(DomainSession session, Tasks tasks) {
    var newTitle = _edit.text;
    var otherTask = tasks.firstWhereAttribute('title', newTitle);
    if (otherTask == null) {
      bool done = new SetAttributeAction(
          session, task, 'title', newTitle).doit();
      if (!done) {
        _edit.setValue(task.title);
        tasks.errors.clear();
      }
    } else {
      _displayTodo();
    }
  }
  
  /**
   * Change LI style depends on task [completed] status.
   */
  complete(bool completed) {
    _completed.setValue(completed);
    if (completed) {
      _li.addStyleName('completed');
    } else {
      _li.removeStyleName('completed');
    }
  }

  /**
   * Remove editing style from LI element.
   */
  _displayTodo() {
    _li.removeStyleName("editing");
  }

  /**
   * Retitle Todo with new [title].
   */
  retitle(String title) {
    _todo.text = title;
    _edit.setValue(title);
    _displayTodo();
  }
  
  /**
   * Mark [widget] attached to RootPanel and remember it for cleanup. 
   */
  void _attachToRootPanel(ui.Widget widget) {
    widget.onAttach();
    ui.RootPanel.detachOnWindowClose(widget);
  }
}