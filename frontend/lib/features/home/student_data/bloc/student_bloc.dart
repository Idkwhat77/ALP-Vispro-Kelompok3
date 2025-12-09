import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/repositories/class_repository.dart';
import '/core/repositories/student_repository.dart';

import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentState.initial()) {
    on<LoadClassesEvent>(_onLoadClasses);
    on<SelectClassEvent>(_onSelectClass);
    on<LoadStudentsEvent>(_onLoadStudents);

    add(LoadClassesEvent());
  }

  Future<void> _onLoadClasses(
      LoadClassesEvent event, Emitter<StudentState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final classes = await ClassRepository.getClasses();
      emit(state.copyWith(classes: classes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: "Failed to load classes: $e",
        isLoading: false,
      ));
    }
  }

  void _onSelectClass(
      SelectClassEvent event, Emitter<StudentState> emit) {
    emit(state.copyWith(selectedClass: event.selectedClass));

    // load students
    add(LoadStudentsEvent(event.selectedClass.classesId));
  }

  Future<void> _onLoadStudents(
      LoadStudentsEvent event, Emitter<StudentState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final students =
          await StudentRepository.getStudentsByClass(event.classId);
      emit(state.copyWith(students: students, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: "Failed to load students: $e",
        isLoading: false,
      ));
    }
  }
}
