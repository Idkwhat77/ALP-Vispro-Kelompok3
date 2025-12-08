import '/core/models/student.dart';
import '/core/models/class.dart';

abstract class StudentEvent {}

class LoadClassesEvent extends StudentEvent {}

class LoadStudentsEvent extends StudentEvent {
  final int classId;
  LoadStudentsEvent(this.classId);
}

class SaveClassEvent extends StudentEvent {
  final String className;
  final int teacherId;
  SaveClassEvent(this.className, this.teacherId);
}

class AddStudentEvent extends StudentEvent {
  final String studentName;
  final int classId;
  AddStudentEvent(this.studentName, this.classId);
}

class EditStudentEvent extends StudentEvent {
  final int studentId;
  final String newName;
  final int classId;

  EditStudentEvent({required this.studentId, required this.newName, required this.classId});
}

class DeleteStudentEvent extends StudentEvent {
  final int studentId;

  DeleteStudentEvent(this.studentId);
}

class SelectClassEvent extends StudentEvent {
  final ClassModel selectedClass;
  SelectClassEvent(this.selectedClass);
}

