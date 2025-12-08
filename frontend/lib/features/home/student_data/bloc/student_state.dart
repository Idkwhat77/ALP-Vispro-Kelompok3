import 'package:frontend/core/models/student.dart';
import 'package:frontend/core/models/class.dart';

class StudentState {
  final String className;
  final List<StudentModel> students;
  final List<ClassModel> classes;
  final ClassModel? selectedClass;
  final bool isLoading;
  final String? error;

  StudentState({
    required this.className,
    required this.students,
    required this.classes,
    this.selectedClass,
    this.isLoading = false,
    this.error,
  });

  factory StudentState.initial() {
    return StudentState(
      className: "",
      students: [],
      classes: [],
      selectedClass: null,
      isLoading: false,
      error: null,
    );
  }

  StudentState copyWith({
    String? className,
    List<StudentModel>? students,
    List<ClassModel>? classes,
    ClassModel? selectedClass,
    bool? isLoading,
    String? error,
  }) {
    return StudentState(
      className: className ?? this.className,
      students: students ?? this.students,
      classes: classes ?? this.classes,
      selectedClass: selectedClass ?? this.selectedClass,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
