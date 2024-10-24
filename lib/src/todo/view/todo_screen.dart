import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/todo_controller.dart';

class TodoScreen extends ConsumerWidget {
  final TextEditingController todoController = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Center(
          child: Text(
            "Todo List:",
            style: TextStyle(
                color: Color(0xFF6750A4),
                fontWeight: FontWeight.bold,
                fontSize: 30,
                decoration: TextDecoration.lineThrough),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: todoController,
              onSubmitted: (value) {
                if (todoController.text.isNotEmpty) {
                  ref.read(todoProvider.notifier).addTask(todoController.text);
                  todoController.clear();
                }
              },
              decoration: InputDecoration(
                hintText: "What to do?",
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xFF6750A4),
                  ),
                  onPressed: () {
                    if (todoController.text.isNotEmpty) {
                      ref
                          .read(todoProvider.notifier)
                          .addTask(todoController.text);
                      todoController.clear();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFC8C8C8)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final task = todoList[index];
                  return Card(
                    color: Colors.white,
                    shadowColor: const Color(0xFF6750A4),
                    child: ListTile(
                      title: Row(
                        children: [
                          Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              ref
                                  .read(todoProvider.notifier)
                                  .completeTask(index);
                            },
                          ),
                          Expanded(
                            child: Text(
                              task.name,
                              style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          ref.read(todoProvider.notifier).deleteTask(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
