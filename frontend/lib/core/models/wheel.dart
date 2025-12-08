class WheelModel {
  final int idWheel;
  final int classesId;
  final String result;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WheelModel({
    required this.idWheel,
    required this.classesId,
    required this.result,
    this.createdAt,
    this.updatedAt,
  });

  factory WheelModel.fromJson(Map<String, dynamic> json) {
    return WheelModel(
      idWheel: json['id_wheel'],
      classesId: json['classes_id'],
      result: json['result'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_wheel': idWheel,
      'classes_id': classesId,
      'result': result,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}