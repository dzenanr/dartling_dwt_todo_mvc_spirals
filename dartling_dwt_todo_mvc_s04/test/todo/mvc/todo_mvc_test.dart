// test/todo/mvc/todo_mvc_test.dart

import "package:test/test.dart";

import "package:dartling/dartling.dart";

import "package:dartling_dwt_todo_mvc/todo_mvc.dart";

testTodoMvc(Repo repo, String domainCode, String modelCode) {
  MvcEntries entries;
  Tasks tasks;
  int length = 0;
  Concept concept;
  group("Testing ${domainCode}.${modelCode}", () {
    setUp(() {
      var models = repo.getDomainModels(domainCode);
      entries = models.getModelEntries(modelCode);
      tasks = entries.tasks;
      concept = tasks.concept;

      var design = new Task(concept);
      design.title = 'design a model';
      tasks.add(design);

      var json = new Task(concept);
      json.title = 'generate json from the model';
      tasks.add(json);

      var generate = new Task(concept);
      generate.title = 'generate code from the json document';
      tasks.add(generate);
    });
    tearDown(() {
      tasks.clear();
      expect(tasks.isEmpty, isTrue);
      length = 0;
    });
    test('Empty Entries Test', () {
      entries.clear();
      expect(entries.isEmpty, isTrue);
    });

    test('From Tasks to JSON', () {
      var json = tasks.toJson();
      expect(json, isNotNull);
      print(json);
    });
    test('From Task Model to JSON', () {
      var json = entries.toJson();
      expect(json, isNotNull);
      entries.displayJson();
    });
    test('From JSON to Task Model', () {
      tasks.clear();
      expect(tasks.isEmpty, isTrue);
      entries.fromJsonToData();
      expect(tasks.isEmpty, isFalse);
      tasks.display(title:'From JSON to Task Model');
    });

    test('Add Task Required Title Error', () {
      var task = new Task(concept);
      expect(concept, isNotNull);
      var added = tasks.add(task);
      expect(added, isFalse);
      expect(tasks.length, equals(length));
      expect(tasks.errors.length, equals(1));
      expect(tasks.errors.toList()[0].category, equals('required'));
      tasks.errors.display(title:'Add Task Required Title Error');
    });

    test('Find Task by New Oid', () {
      var oid = new Oid.ts(1345648254063);
      var task = tasks.singleWhereOid(oid);
      expect(task, isNull);
    });
    test('Find Task by Attribute', () {
      var title = 'generate json from the model';
      var task = tasks.firstWhereAttribute('title', title);
      expect(task, isNotNull);
      expect(task.title, equals(title));
    });
    test('Random Task', () {
      var task1 = tasks.random();
      expect(task1, isNotNull);
      task1.display(prefix:'random 1');
      var task2 = tasks.random();
      expect(task2, isNotNull);
      task2.display(prefix:'random 2');
    });

    test('Find Task then Set Oid with Failure', () {
      var title = 'generate json from the model';
      var task = tasks.firstWhereAttribute('title', title);
      expect(task, isNotNull);
      expect(() => task.oid = new Oid.ts(1345648254063), throws);
    });
    test('Find Task then Set Oid with Success', () {
      var title = 'generate json from the model';
      var task = tasks.firstWhereAttribute('title', title);
      expect(task, isNotNull);
      task.display(prefix:'before oid set: ');
      task.concept.updateOid = true;
      task.oid = new Oid.ts(1345648254063);
      task.concept.updateOid = false;
      task.display(prefix:'after oid set: ');
    });

    test('Update New Task Title with Failure', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.length, equals(++length));

      var copiedTask = task.copy();
      copiedTask.title = 'writing a paper on Dartling';
      // Entities.update can only be used if oid, code or id set.
      expect(() => tasks.update(task, copiedTask), throws);
    });
    test('Update New Task Oid with Success', () {
      var task = new Task(concept);
      expect(task, isNotNull);
      task.title = 'writing a tutorial on Dartling';
      tasks.add(task);
      expect(tasks.length, equals(++length));

      var copiedTask = task.copy();
      copiedTask.concept.updateOid = true;
      copiedTask.oid = new Oid.ts(1345648254063);
      copiedTask.concept.updateOid = false;
      // Entities.update can only be used if oid, code or id set.
      tasks.update(task, copiedTask);
      var foundTask = tasks.firstWhereAttribute('title', task.title);
      expect(foundTask, isNotNull);
      expect(foundTask.oid, equals(copiedTask.oid));
      // Entities.update removes the before update entity and
      // adds the after update entity,
      // in order to update oid, code and id entity maps.
      expect(task.oid, isNot(equals(copiedTask.oid)));
    });
    test('Find Task by Attribute then Examine Code and Id', () {
      var title = 'generate json from the model';
      var task = tasks.firstWhereAttribute('title', title);
      expect(task, isNotNull);
      expect(task.code, isNull);
      expect(task.id, isNull);
    });
  });
}

testTodoData(TodoRepo todoRepo) {
  testTodoMvc(todoRepo, TodoRepo.todoDomainCode,
      TodoRepo.todoMvcModelCode);
}

void main() {
  var todoRepo = new TodoRepo();
  testTodoData(todoRepo);
}

