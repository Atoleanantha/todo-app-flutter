class Todo {
  final String id;
  final String task;
  final String description;
  final bool isPriority;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.task,
    required this.description,
    required this.isPriority,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      description: json['description'],
      isPriority: json['isPriority'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'description': description,
      'isPriority': isPriority,
      'isCompleted': isCompleted,
    };
  }

  Todo copyWith({
    String? id,
    String? task,
    String? description,
    bool? isPriority,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      isPriority: isPriority ?? this.isPriority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
