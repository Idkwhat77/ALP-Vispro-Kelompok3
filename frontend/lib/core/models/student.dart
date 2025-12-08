class StudentModel {
  final int idStudents;
  final int classesId;
  final String studentName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentModel({
    required this.idStudents,
    required this.classesId,
    required this.studentName,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      idStudents: json['id_students'],
      classesId: json['classes_id'],
      studentName: json['student_name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_students': idStudents,
      'classes_id': classesId,
      'student_name': studentName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}