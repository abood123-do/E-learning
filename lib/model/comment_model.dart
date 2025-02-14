class Comment {
  int id;
  int userId;
  int courseSessionId;
  String note;
  DateTime createdAt;
  DateTime updatedAt;

  Comment({
    required this.id,
    required this.userId,
    required this.courseSessionId,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: int.parse(json['user_id'].toString()),
      courseSessionId: int.parse(json['course_session_id'].toString()),
      note: json['note'] ?? 'No Note',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
