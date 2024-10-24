import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

class TodoController extends StateNotifier<List<Todo>> {
  TodoController() : super([]) {
    _loadTasks();
  }

  void addTask(String task) {
    state = [Todo(name: task, isCompleted: false), ...state];
    _saveTasks();
  }

  void completeTask(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].modelData(isCompleted: !state[i].isCompleted)
        else
          state[i]
    ];
    _saveTasks();
  }

  void deleteTask(int index) {
    state = state
        .asMap()
        .entries
        .where((entry) => entry.key != index)
        .map((entry) => entry.value)
        .toList();
    _saveTasks();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> serializedTasks = state
        .map((Todo todo) => '${todo.name}|${todo.isCompleted ? 1 : 0}')
        .toList();
    prefs.setStringList('tasks', serializedTasks);
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? serializedTasks = prefs.getStringList('tasks');
    if (serializedTasks != null) {
      state = serializedTasks
          .map((String serialized) => _deserializeTask(serialized))
          .toList();
    }
  }

  Todo _deserializeTask(String serialized) {
    final parts = serialized.split('|');
    return Todo(
      name: parts[0],
      isCompleted: parts[1] == '1',
    );
  }
}

final todoProvider = StateNotifierProvider<TodoController, List<Todo>>((ref) {
  return TodoController();
});
