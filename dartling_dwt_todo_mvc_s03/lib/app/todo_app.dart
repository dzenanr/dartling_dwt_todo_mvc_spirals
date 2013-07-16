part of todo_mvc_app;

class TodoApp {
  TodoModels domain;
  DomainSession session;
  Tasks tasks;

  TodoApp(this.domain) {
    session = domain.newSession();
    MvcEntries model = domain.getModelEntries('Mvc');
    tasks = model.tasks;

    var rootPanel = ui.RootLayoutPanel.get();
    var vPanel = new ui.VerticalPanel();
    vPanel.spacing = 10;
    rootPanel.add(vPanel);
    var title = new ui.Label('Todos');
    vPanel.add(title);
    var header = new Header(this);
    vPanel.add(header);
    var todos = new Todos(this);
    vPanel.add(todos);
  }

  save() {
    window.localStorage['tasks'] = stringify(tasks.toJson());
  }
}

