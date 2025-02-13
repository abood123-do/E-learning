import 'package:login/model/session_model.dart';

class Course {
  int id;
  String title;
  String? description;
  int levelId;
  String? image;
  int? hours;
  bool isRegistered;
  DateTime createdAt;
  DateTime updatedAt;
  List<Session> sessions;

  Course({
    required this.id,
    required this.title,
    required this.image,
    required this.hours,
    required this.isRegistered,
    this.description,
    required this.levelId,
    required this.createdAt,
    required this.sessions,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    final data = json['course_sessions'] as List;
    List<Session> allSessions = data.map((e) => Session.fromJson(e)).toList();
    return Course(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      sessions: allSessions,
      isRegistered: json['is_registered'],
      hours: int.parse(json['hours'] ?? '0'),
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
