part of todo_mvc_app;

class TodoApp {
  TodoModels domain;
  DomainSession session;
  Tasks tasks;

  TodoApp(this.domain) {
    session = domain.newSession();
    MvcEntries model = domain.getModelEntries('Mvc');
    tasks = model.tasks;

    var root = ui.RootPanel.get();
    var todoApp = new ui.VerticalPanel();
    todoApp.spacing = 8;
    root.add(todoApp);
    var header = new Header(this);
    todoApp.add(header);
    var todos = new Todos(this);
    todoApp.add(todos);
  }

  save() {
    window.localStorage['tasks'] = stringify(tasks.toJson());
  }
}

