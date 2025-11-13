import 'package:todo/data/app_database.dart';

class TodoRepository {
  final AppDatabase db;
  TodoRepository(this.db);

  Future<List<Todo>> getAll() => db.getAll();
  Stream<List<Todo>> watchAll() => db.watchAll();
  Future<void> insertTodo(String title) => db.insertTodo(title);
  Future<void> toggle(int id, bool next) => db.toggle(id, next);
  Future<void> remove(int id) => db.remove(id);
  Future<void> clearDone() => db.clearDone();
}
