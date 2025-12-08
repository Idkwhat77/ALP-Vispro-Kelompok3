class Teacher {
  final int teacherId;
  final String username;
  final String email;

  Teacher({
    required this.teacherId,
    required this.username,
    required this.email,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherId: json['teacher_id'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'username': username,
      'email': email,
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