import 'dart:async';
import 'package:equatable/equatable.dart';
import '../../../core/models/class.dart';

class SpinwheelState extends Equatable {
  final List<String> items;
  final int? selectedIndex;
  final bool isSpinning;
  final bool removeOnSelect;
  final StreamController<int> selectedController;
  final List<ClassModel> classes;
  final ClassModel? selectedClass;
  final bool isLoading;
  final String? error;

  const SpinwheelState({
    required this.items,
    required this.selectedController,
    this.selectedIndex,
    this.isSpinning = false,
    this.removeOnSelect = false,
    this.classes = const [],
    this.selectedClass,
    this.isLoading = false,
    this.error,
  });

  SpinwheelState copyWith({
    List<String>? items,
    int? selectedIndex,
    bool? isSpinning,
    bool? removeOnSelect,
    StreamController<int>? selectedController,
    List<ClassModel>? classes,
    ClassModel? selectedClass,
    bool? isLoading,
    String? error,
  }) {
    return SpinwheelState(
      items: items ?? this.items,
      selectedController: selectedController ?? this.selectedController,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isSpinning: isSpinning ?? this.isSpinning,
      removeOnSelect: removeOnSelect ?? this.removeOnSelect,
      classes: classes ?? this.classes,
      selectedClass: selectedClass ?? this.selectedClass,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  // intentionally omit selectedController from props to avoid comparing controller object
  List<Object?> get props => [
    items, 
    selectedIndex, 
    isSpinning, 
    removeOnSelect,
    classes,
    selectedClass,
    isLoading,
    error,
  ];
}