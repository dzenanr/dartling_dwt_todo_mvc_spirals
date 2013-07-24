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

  bool preSetAttribute(String name, Object value) {
    bool validation = super.preSetAttribute(name, value);
    if (name == 'title') {
      String title = value;
      if (validation) {
        validation = title.trim() != '';
        if (!validation) {
          var error = new ValidationError('pre');
          error.message = 'The title should not be empty.';
          errors.add(error);
        }
      }
      if (validation) {
        validation = title.length <= 64;
        if (!validation) {
          var error = new ValidationError('pre');
          error.message =
              'The "${title}" title should not be longer than 64 characters.';
              errors.add(error);
        }
      }
    }
    return validation;
  }
  // end: added by hand
}

class Tasks extends TasksGen {

  Tasks(Concept concept) : super(concept);

  // begin: added by hand
  Tasks get completed => selectWhere((task) => task.completed);
  Tasks get left => selectWhere((task) => task.left);

  bool preAdd(Task task) {
    bool validation = super.preAdd(task);
    if (validation) {
      var otherTask = firstWhereAttribute('title', task.title);
      validation = otherTask == null;
      if (!validation) {
        var error = new ValidationError('pre');
        error.message = 'The "${task.title}" title already exists.';
        errors.add(error);
      }
    }
    return validation;
  }
  // end: added by hand
}
