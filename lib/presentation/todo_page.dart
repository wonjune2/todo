import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/application/todo_list.dart';
import 'package:todo/domain/todo.dart';

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    ref.read(todoListProvider.notifier).add(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo (Riverpod Level 1)'),
        actions: [
          IconButton(
            onPressed: () => ref.read(todoListProvider.notifier).cleanDone(),
            icon: const Icon(Icons.cleaning_services_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "할 일을 입력하세요.",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('추가')),
              ],
            ),
          ),
          Expanded(
            child: todos.isEmpty
                ? const _EmptyView()
                : ListView.separated(
                    itemBuilder: (_, i) {
                      final Todo t = todos[i];
                      return ListTile(
                        leading: Checkbox(
                          value: t.done,
                          onChanged: (_) =>
                              ref.read(todoListProvider.notifier).toggle(t.id),
                        ),
                        title: Text(
                          t.title,
                          style: TextStyle(
                            decoration: t.done
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () =>
                              ref.read(todoListProvider.notifier).remove(t.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: todos.length,
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '아직 할 일이 없어요.\n위 입력창에 적고 [추가]를 눌러보세요!',
        textAlign: TextAlign.center,
      ),
    );
  }
}
