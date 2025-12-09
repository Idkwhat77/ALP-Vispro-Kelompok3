import 'package:frontend/core/models/student.dart';
import 'package:frontend/core/models/class.dart';

class StudentState {
  final List<ClassModel> classes;
  final List<StudentModel> students;
  final ClassModel? selectedClass;

  final bool isLoading;
  final String? error;

  StudentState({
    required this.classes,
    required this.students,
    this.selectedClass,
    this.isLoading = false,
    this.error,
  });

  factory StudentState.initial() {
    return StudentState(
      classes: [],
      students: [],
      selectedClass: null,
      isLoading: false,
      error: null,
    );
  }

  StudentState copyWith({
    List<ClassModel>? classes,
    List<StudentModel>? students,
    ClassModel? selectedClass,
    bool? isLoading,
    String? error,
  }) {
    return StudentState(
      classes: classes ?? this.classes,
      students: students ?? this.students,
      selectedClass: selectedClass ?? this.selectedClass,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
