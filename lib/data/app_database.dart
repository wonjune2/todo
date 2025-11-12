import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // -- CRUD helpers
  Future<List<Todo>> getAll() => select(todos).get();
  Stream<List<Todo>> watchAll() =>
      (select(todos)..orderBy([(t) => OrderingTerm.desc(t.id)])).watch();

  Future<int> insertTodo(String title) =>
      into(todos).insert(TodosCompanion.insert(title: title));

  Future<int> toggle(int id, bool next) => (update(
    todos,
  )..where((t) => t.id.equals(id))).write(TodosCompanion(done: Value(next)));

  Future<int> remove(int id) =>
      (delete(todos)..where((t) => t.id.equals(id))).go();

  Future<int> clearDone() =>
      (delete(todos)..where((t) => t.done.equals(true))).go();

  static _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
