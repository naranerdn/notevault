class Todoitem {
  final int? id;
  final String content;
  bool completed;

  Todoitem({
    this.id,
    required this.content,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'completed': completed ? 1 : 0, // Store as 1 (true) or 0 (false)
    };
  }

  factory Todoitem.fromMap(Map<String, dynamic> map) {
    return Todoitem(
      id: map['id'],
      content: map['content'],
      completed: map['completed'] == 1, // Convert 1 (true) to bool
    );
  }
}
