class Course {
  int id;
  String title;
  String? description;
  int levelId;
  DateTime createdAt;
  DateTime updatedAt;

  Course({
    required this.id,
    required this.title,
    this.description,
    required this.levelId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? 'No Description',
      levelId: json['level_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'level_id': levelId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
