part of todo_mvc_app;

class TodoApp {
  TodoModels domain;
  DomainSession session;
  Tasks tasks;

  Header header;
  Footer footer;

  TodoApp(this.domain) {
    session = domain.newSession();
    MvcEntries model = domain.getModelEntries('Mvc');
    tasks = model.tasks;

    var root = ui.RootPanel.get();
    var todoApp = new ui.VerticalPanel();
    todoApp.spacing = 8;
    root.add(todoApp);
    header = new Header(this);
    todoApp.add(header);
    var todos = new Todos(this);
    todoApp.add(todos);
    footer = new Footer(this, todos);
    todoApp.add(footer);

    updateDisplay();
  }

  save() {
    window.localStorage['tasks'] = JSON.encode(tasks.toJson());
  }

  updateDisplay() {
    header.updateDisplay();
    footer.updateDisplay();
  }
}

