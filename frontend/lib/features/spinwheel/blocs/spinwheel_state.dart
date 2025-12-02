import 'dart:async';
import 'package:equatable/equatable.dart';

class SpinwheelState extends Equatable {
  final List<String> items;
  final int? selectedIndex;
  final bool isSpinning;
  final bool removeOnSelect;
  final StreamController<int> selectedController;

  const SpinwheelState({
    required this.items,
    required this.selectedController,
    this.selectedIndex,
    this.isSpinning = false,
    this.removeOnSelect = false,
  });

  SpinwheelState copyWith({
    List<String>? items,
    int? selectedIndex,
    bool? isSpinning,
    bool? removeOnSelect,
    StreamController<int>? selectedController,
  }) {
    return SpinwheelState(
      items: items ?? this.items,
      selectedController: selectedController ?? this.selectedController,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isSpinning: isSpinning ?? this.isSpinning,
      removeOnSelect: removeOnSelect ?? this.removeOnSelect,
    );
  }

  @override
  // intentionally omit selectedController from props to avoid comparing controller object
  List<Object?> get props => [items, selectedIndex, isSpinning, removeOnSelect];
}