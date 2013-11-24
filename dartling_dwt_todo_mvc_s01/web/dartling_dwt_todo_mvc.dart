
import 'package:dartling_dwt_todo_mvc/todo_mvc.dart';
import 'package:dartling_dwt_todo_mvc/todo_mvc_app.dart';

main() {
  var repo = new TodoRepo();
  var domain = repo.getDomainModels('Todo');
  var model = domain.getModelEntries('Mvc');
  //initTodoMvc(model);
  new TodoApp(model.tasks);
}



