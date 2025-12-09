import 'teacher.dart';

class ClassModel {
  final int classesId;
  final int teacherId;
  final String className;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Teacher? teacher; // Add teacher relationship

  ClassModel({
    required this.classesId,
    required this.teacherId,
    required this.className,
    this.createdAt,
    this.updatedAt,
    this.teacher,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classesId: json['classes_id'],
      teacherId: json['teacher_id'],
      className: json['class_name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      teacher: json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classes_id': classesId,
      'teacher_id': teacherId,
      'class_name': className,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      if (teacher != null) 'teacher': teacher!.toJson(),
    };
  }
}