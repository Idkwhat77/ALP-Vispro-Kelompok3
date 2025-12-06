import 'package:flutter_bloc/flutter_bloc.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentState.initial()) {
    on<SaveClassEvent>((event, emit) {
      emit(state.copyWith(className: event.className));
    });

    on<AddStudentEvent>((event, emit) {
      if (event.studentName.trim().isEmpty) return;
      final newList = List<String>.from(state.students)..add(event.studentName);
      emit(state.copyWith(students: newList));
    });

    on<EditStudentEvent>((event, emit) {
      final updated = List<String>.from(state.students);
      updated[event.index] = event.newName;
      emit(state.copyWith(students: updated));
    });

    on<DeleteStudentEvent>((event, emit) {
      final updated = List<String>.from(state.students)..removeAt(event.index);
      emit(state.copyWith(students: updated));
    });
  }
}
