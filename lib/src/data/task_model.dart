class Tasks {
  final int id;
  final String title;
  final bool completed;
  final String priority;

  Tasks({
    required this.id,
    required this.title,
    required this.completed,
    required this.priority,
  });

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      id: map['id'] as int,
      title: map['title'] as String,
      completed: map['completed'] as bool,
      priority: map['priority'] as String,
    );
  }
}
