enum Priority { low, medium, high }

class Task {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final Priority priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.priority = Priority.medium,
  });

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    Priority? priority,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "isCompleted": isCompleted,
    "priority": priority.name,
  };

  static Task fromJson(Map<String, dynamic> json) {
    final p = (json["priority"] as String?) ?? 'medium';
    return Task(
      id: json["id"],
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      isCompleted: json["isCompleted"] ?? false,
      priority: Priority.values.firstWhere(
              (e) => e.name == p,
          orElse: () => Priority.medium),
    );
  }
}
