part of todo_mvc_app;

class TodoApp {
  TodoApp(Tasks tasks) {
    var rootPanel = ui.RootLayoutPanel.get();
    var vPanel = new ui.VerticalPanel();
    vPanel.spacing = 10;
    rootPanel.add(vPanel);
    var title = new ui.Label('Todos');
    vPanel.add(title);
    var todos = new Todos(tasks);
    vPanel.add(todos);
  }
}

