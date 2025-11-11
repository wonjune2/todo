import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/todo.dart';

final todoListProvider = NotifierProvider<TodoList, List<Todo>>(TodoList.new);

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return const <Todo>[];
  }

  void add(String title) {
    final t = title.trim();
    if (t.isEmpty) return;
    final id =
        '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1000)}';
    state = [...state, Todo(id: id, title: t)];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(done: !todo.done) else todo,
    ];
  }

  void remove(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void cleanDone() {
    state = state.where((e) => !e.done).toList();
  }
}
