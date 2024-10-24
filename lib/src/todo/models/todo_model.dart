class Todo {
  final String name;
  final bool isCompleted;

  Todo({required this.name, required this.isCompleted});

  Todo modelData({String? name, bool? isCompleted}) {
    return Todo(
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
