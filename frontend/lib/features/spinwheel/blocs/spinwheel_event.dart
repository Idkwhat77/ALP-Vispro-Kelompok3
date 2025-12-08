import 'package:equatable/equatable.dart';

abstract class SpinwheelEvent extends Equatable {
  const SpinwheelEvent();
  @override
  List<Object?> get props => [];
}

class AddItem extends SpinwheelEvent {
  final String item;
  const AddItem(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveItemAt extends SpinwheelEvent {
  final int index;
  const RemoveItemAt(this.index);
  @override
  List<Object?> get props => [index];
}

class EditItem extends SpinwheelEvent {
  final int index;
  final String newValue;
  const EditItem({required this.index, required this.newValue});
  @override
  List<Object?> get props => [index, newValue];
}

class ToggleRemoveOnSelect extends SpinwheelEvent {
  final bool enabled;
  const ToggleRemoveOnSelect(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class ShuffleItems extends SpinwheelEvent {
  const ShuffleItems();
}

class LoadClass extends SpinwheelEvent {
  final List<String> items;
  const LoadClass(this.items);
  @override
  List<Object?> get props => [items];
}

class SpinWheel extends SpinwheelEvent {
  const SpinWheel();
}

class FinishSpin extends SpinwheelEvent {
  final int index;
  const FinishSpin(this.index);
  @override
  List<Object?> get props => [index];
}

class ClearItems extends SpinwheelEvent {
  const ClearItems();
}

class LoadClassesFromAPI extends SpinwheelEvent {
  const LoadClassesFromAPI();
}

class LoadStudentsFromClass extends SpinwheelEvent {
  final int classId;
  const LoadStudentsFromClass(this.classId);
  @override
  List<Object?> get props => [classId];
}

class SaveWheelResult extends SpinwheelEvent {
  final int classId;
  final String winnerId;
  final String winnerName;
  const SaveWheelResult({
    required this.classId, 
    required this.winnerId,
    required this.winnerName,
  });
  @override
  List<Object?> get props => [classId, winnerId, winnerName];
}