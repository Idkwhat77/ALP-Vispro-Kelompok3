import '/core/models/class.dart';

abstract class StudentEvent {}

class LoadClassesEvent extends StudentEvent {}

class SelectClassEvent extends StudentEvent {
  final ClassModel selectedClass;
  SelectClassEvent(this.selectedClass);
}

class LoadStudentsEvent extends StudentEvent {
  final int classId;
  LoadStudentsEvent(this.classId);
}
