class Session {
  final int id;
  final int courseId;
  final String sessionTitle;
  final String video;
  final DateTime createdAt;
  final DateTime updatedAt;

  Session({
    required this.id,
    required this.courseId,
    required this.sessionTitle,
    required this.video,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      courseId: json['course_id'],
      sessionTitle: json['test'] ?? 'No title',
      video: json['video'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
