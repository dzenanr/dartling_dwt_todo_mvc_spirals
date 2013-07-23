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

    var infoPanel = new ui.VerticalPanel();
    infoPanel.addStyleName('info');
    todoApp.add(infoPanel);
    var todo_edit_info = new ui.Label('Double-click to edit a todo');
    infoPanel.add(todo_edit_info);
    var linkPanel = new ui.HorizontalPanel();
    linkPanel.spacing = 4;
    infoPanel.add(linkPanel);
    var dartling = new ui.Anchor()
      ..text="dartling"
      ..href="https://github.com/dzenanr/dartling";
    linkPanel.add(dartling);
    var dwt = new ui.Anchor()
      ..text="DWT"
      ..href="http://dartwebtoolkit.com";
    linkPanel.add(dwt);
    var todoMvc = new ui.Anchor()
      ..text="Todo MVC"
      ..href="http://todomvc.com";
    linkPanel.add(todoMvc);
  }

  save() {
    window.localStorage['tasks'] = stringify(tasks.toJson());
  }

  updateDisplay() {
    header.updateDisplay();
    footer.updateDisplay();
  }
}

