class StudentState {
  final String className;
  final List<String> students;

  StudentState({
    required this.className,
    required this.students,
  });

  factory StudentState.initial() {
    return StudentState(
      className: "",
      students: [],
    );
  }

  StudentState copyWith({
    String? className,
    List<String>? students,
  }) {
    return StudentState(
      className: className ?? this.className,
      students: students ?? this.students,
    );
    }
}
