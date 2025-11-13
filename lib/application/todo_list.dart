import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/app_database.dart';
import 'package:todo/data/todo_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final todoRepoProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(ref.read(databaseProvider)),
);

final todoListProvider = AsyncNotifierProvider<TodoList, List<Todo>>(
  TodoList.new,
);

class TodoList extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // 초기 값: 현재 DB 스냅샷
    final repo = ref.read(todoRepoProvider);
    // DB 변경을 실시간 반영
    ref.onDispose(() {}); // 필요 시 정리
    repo.watchAll().listen((rows) {
      state = AsyncData(rows);
    });

    return repo.db.getAll();
  }

  Future<void> add(String title) async {
    final t = title.trim();
    if (t.isEmpty) return;
    await ref.read(todoRepoProvider).insertTodo(t);
  }

  Future<void> toggle(int id) async {
    final current = state.value ?? [];
    final row = current.firstWhere((e) => e.id == id);
    await ref.read(todoRepoProvider).toggle(id, !row.done);
  }

  Future<void> remove(int id) async {
    await ref.read(todoRepoProvider).remove(id);
    // state = state.where((e) => e.id != id).toList();
  }

  Future<void> cleanDone() async {
    await ref.read(todoRepoProvider).clearDone();
    //state = state.where((e) => !e.done).toList();
  }
}
