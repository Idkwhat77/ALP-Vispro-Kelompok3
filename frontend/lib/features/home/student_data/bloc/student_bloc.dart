import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/repositories/student_repository.dart';
import '/core/repositories/class_repository.dart';
import '/core/repositories/auth_repository.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentState.initial()) {
    on<LoadClassesEvent>(_onLoadClasses);
    on<LoadStudentsEvent>(_onLoadStudents);
    on<SaveClassEvent>(_onSaveClass);
    on<AddStudentEvent>(_onAddStudent);
    on<EditStudentEvent>(_onEditStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
    on<SelectClassEvent>(_onSelectClass);

    // Auto load classes when bloc is created
    add(LoadClassesEvent());
  }

  Future<void> _onLoadClasses(LoadClassesEvent event, Emitter<StudentState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final classes = await ClassRepository.getClasses();
      emit(state.copyWith(
        classes: classes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load classes: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadStudents(LoadStudentsEvent event, Emitter<StudentState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final students = await StudentRepository.getStudentsByClass(event.classId);
      emit(state.copyWith(
        students: students,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load students: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSaveClass(SaveClassEvent event, Emitter<StudentState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final newClass = await ClassRepository.createClass(event.className, event.teacherId);
      if (newClass != null) {
        final updatedClasses = [...state.classes, newClass];
        emit(state.copyWith(
          classes: updatedClasses,
          className: event.className,
          selectedClass: newClass,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to create class',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to save class: ${e.toString()}',
      ));
    }
  }

  Future<void> _onAddStudent(AddStudentEvent event, Emitter<StudentState> emit) async {
    if (event.studentName.trim().isEmpty) return;
    
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final newStudent = await StudentRepository.createStudent(event.studentName, event.classId);
      if (newStudent != null) {
        final updatedStudents = [...state.students, newStudent];
        emit(state.copyWith(
          students: updatedStudents,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to add student',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to add student: ${e.toString()}',
      ));
    }
  }

  Future<void> _onEditStudent(EditStudentEvent event, Emitter<StudentState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final updatedStudent = await StudentRepository.updateStudent(
        event.studentId, 
        event.newName, 
        event.classId
      );
      
      if (updatedStudent != null) {
        final updatedStudents = state.students.map((student) {
          return student.idStudents == event.studentId ? updatedStudent : student;
        }).toList();
        
        emit(state.copyWith(
          students: updatedStudents,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to update student',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to update student: ${e.toString()}',
      ));
    }
  }

  Future<void> _onDeleteStudent(DeleteStudentEvent event, Emitter<StudentState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final success = await StudentRepository.deleteStudent(event.studentId);
      if (success) {
        final updatedStudents = state.students
            .where((student) => student.idStudents != event.studentId)
            .toList();
        emit(state.copyWith(
          students: updatedStudents,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to delete student',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to delete student: ${e.toString()}',
      ));
    }
  }

  void _onSelectClass(SelectClassEvent event, Emitter<StudentState> emit) {
    emit(state.copyWith(
      selectedClass: event.selectedClass,
      className: event.selectedClass.className,
    ));
    
    // Load students for the selected class
    add(LoadStudentsEvent(event.selectedClass.classesId));
  }
}
