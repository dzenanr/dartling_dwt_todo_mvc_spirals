part of todo_mvc;

// lib/todo/mvc/tasks.dart

class Task extends TaskGen {

  Task(Concept concept) : super(concept);

  Task.withId(Concept concept, String title) :
    super.withId(concept, title);

  // begin: added by hand
  bool get left => !completed;
  bool get generate =>
      title.contains('generate') ? true : false;
  // end: added by hand

}

class Tasks extends TasksGen {

  Tasks(Concept concept) : super(concept);

  // begin: added by hand
  Tasks get completed => selectWhere((task) => task.completed);
  Tasks get left => selectWhere((task) => task.left);

  Task findByTitleId(String title) {
    return singleWhereId(new Id(concept)..setAttribute('title', title));
  }

  bool preAdd(Task task) {
    bool validation = super.preAdd(task);
    if (validation) {
      validation = task.title.length <= 64;
      if (!validation) {
        var error = new ValidationError('pre');
        error.message =
            'The "${task.title}" title should not be longer than 64 characters.';
        errors.add(error);
      }
    }
    return validation;
  }
  // end: added by hand

}
