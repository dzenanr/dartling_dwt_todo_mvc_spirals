part of todo_mvc;

// lib/todo/mvc/tasks.dart

class Task extends TaskGen {

  Task(Concept concept) : super(concept);

  // begin: added by hand
  bool get left => !completed;
  bool get generate =>
      title.contains('generate') ? true : false;

  /**
   * Compares two tasks based on the title.
   * If the result is less than 0 then the first entity is less than the second,
   * if it is equal to 0 they are equal and
   * if the result is greater than 0 then the first is greater than the second.
   */
  int compareTo(Task other) {
    return title.compareTo(other.title);
  }
  // end: added by hand

}

class Tasks extends TasksGen {

  Tasks(Concept concept) : super(concept);

  // begin: added by hand
  Tasks get completed => selectWhere((task) => task.completed);
  Tasks get left => selectWhere((task) => task.left);
  // end: added by hand

}
