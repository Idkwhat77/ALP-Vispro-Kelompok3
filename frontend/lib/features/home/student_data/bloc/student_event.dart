abstract class StudentEvent {}

class SaveClassEvent extends StudentEvent {
  final String className;
  SaveClassEvent(this.className);
}

class AddStudentEvent extends StudentEvent {
  final String studentName;
  AddStudentEvent(this.studentName);
}

class EditStudentEvent extends StudentEvent {
  final int index;
  final String newName;

  EditStudentEvent({required this.index, required this.newName});
}

class DeleteStudentEvent extends StudentEvent {
  final int index;

  DeleteStudentEvent(this.index);
}

