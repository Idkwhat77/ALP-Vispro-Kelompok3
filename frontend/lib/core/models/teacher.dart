class Teacher {
  final int teacherId;
  final String username;
  final String fullname;
  final String email;
  final String? specialist;
  final String? pictureUrl;

  Teacher({
    required this.teacherId,
    required this.username,
    required this.fullname,
    required this.email,
    this.specialist,
    this.pictureUrl,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherId: json['teacher_id'],
      username: json['username'],
      fullname: json['fullname'] ?? json['username'],
      email: json['email'],
      specialist: json['specialist'],
      pictureUrl: json['picture_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'username': username,
      'fullname': fullname,
      'email': email,
      'specialist': specialist,
      'picture_url': pictureUrl,
    };
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final Teacher teacher;
  final String token;

  LoginResponse({
    required this.success,
    required this.message,
    required this.teacher,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      teacher: Teacher.fromJson(json['teacher']),
      token: json['token'],
    );
  }
}