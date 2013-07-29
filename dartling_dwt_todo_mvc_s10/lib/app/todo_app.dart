part of todo_mvc_app;

/**
 * Todo Application entry point.
 */
class TodoApp {
  TodoModels domain;
  DomainSession session;
  Tasks tasks;

  Header header;
  Footer footer;

  /**
   * Create new instance of [TodoApp].
   */
  TodoApp(this.domain) {
    
    session = domain.newSession();
    MvcEntries model = domain.getModelEntries('Mvc');
    tasks = model.tasks;

    header = new Header(this);
    Todos todos = new Todos(this);
    footer = new Footer(this, todos);
    
    updateDisplay();

  }

  /**
   * Save list of task to local storage.
   */
  save() {
    window.localStorage['todos-dartling-dwt'] = stringify(tasks.toJson());
  }

  /**
   * Update header and footer components on page.
   */
  updateDisplay() {
    header.updateDisplay();
    footer.updateDisplay();
  }
}

