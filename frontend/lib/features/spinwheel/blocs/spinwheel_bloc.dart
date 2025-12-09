import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import '../../../core/models/class.dart';
import '../../../core/repositories/class_repository.dart';
import '../../../core/repositories/student_repository.dart';
import '../../../core/repositories/wheel_repository.dart';
import 'spinwheel_event.dart';
import 'spinwheel_state.dart';

class SpinwheelBloc extends Bloc<SpinwheelEvent, SpinwheelState> {
  final StreamController<int> _selectedController = StreamController<int>.broadcast();
  final Random _rnd = Random();

  SpinwheelBloc()
      : super(SpinwheelState(
          items: const [],
          selectedController: StreamController<int>.broadcast(),
        )) {

    on<AddItem>(_onAddItem);
    on<RemoveItemAt>(_onRemoveItemAt);
    on<EditItem>(_onEditItem);
    on<ToggleRemoveOnSelect>(_onToggleRemoveOnSelect);
    on<ShuffleItems>(_onShuffleItems);
    on<LoadClass>(_onLoadClass);
    on<SpinWheel>(_onSpinWheel);
    on<FinishSpin>(_onFinishSpin);
    on<ClearItems>(_onClearItems);
    on<LoadClassesFromAPI>(_onLoadClassesFromAPI);
    on<LoadStudentsFromClass>(_onLoadStudentsFromClass);
    on<SaveWheelResult>(_onSaveWheelResult);

    // Auto load classes when bloc is created
    add(const LoadClassesFromAPI());
  }

  Stream<int> get selectedStream => _selectedController.stream;

  void _onAddItem(AddItem event, Emitter<SpinwheelState> emit) {
    final newItems = List<String>.from(state.items)..add(event.item);
    emit(state.copyWith(items: newItems));
  }

  void _onRemoveItemAt(RemoveItemAt event, Emitter<SpinwheelState> emit) {
    final idx = event.index;
    final newItems = List<String>.from(state.items);
    if (idx >= 0 && idx < newItems.length) {
      newItems.removeAt(idx);
    }
    int? newSelected = state.selectedIndex;
    if (newItems.isEmpty) {
      newSelected = null;
    } else if (newSelected != null && newSelected >= newItems.length) newSelected = null;
    emit(state.copyWith(items: newItems, selectedIndex: newSelected));
  }

  void _onEditItem(EditItem event, Emitter<SpinwheelState> emit) {
    final idx = event.index;
    final newItems = List<String>.from(state.items);
    if (idx >= 0 && idx < newItems.length) {
      newItems[idx] = event.newValue;
      emit(state.copyWith(items: newItems));
    }
  }

  void _onToggleRemoveOnSelect(ToggleRemoveOnSelect event, Emitter<SpinwheelState> emit) {
    emit(state.copyWith(removeOnSelect: event.enabled));
  }

  void _onShuffleItems(ShuffleItems event, Emitter<SpinwheelState> emit) {
    final newItems = List<String>.from(state.items);
    newItems.shuffle(_rnd);
    emit(state.copyWith(items: newItems));
  }

  void _onLoadClass(LoadClass event, Emitter<SpinwheelState> emit) {
    final newItems = List<String>.from(event.items);
    emit(state.copyWith(items: newItems));
  }

  Future<void> _onSpinWheel(SpinWheel event, Emitter<SpinwheelState> emit) async {
    if (state.items.isEmpty) return;
    final index = _rnd.nextInt(state.items.length);
    emit(state.copyWith(isSpinning: true, selectedIndex: index));
    try {
      _selectedController.add(index);
    } catch (_) {}
    // wait for FinishSpin event which will be triggered by UI after animation end
  }

  void _onFinishSpin(FinishSpin event, Emitter<SpinwheelState> emit) {
    final idx = event.index;
    final bool remove = state.removeOnSelect;
    List<String> newItems = List<String>.from(state.items);
    int? newSelected = idx;
    if (remove && newItems.isNotEmpty && idx >= 0 && idx < newItems.length) {
      newItems.removeAt(idx);
      if (newItems.isEmpty) {
        newSelected = null;
      } else if (newSelected >= newItems.length) newSelected = null;
    }
    emit(state.copyWith(items: newItems, selectedIndex: newSelected, isSpinning: false));
  }

  void _onClearItems(ClearItems event, Emitter<SpinwheelState> emit) {
    emit(state.copyWith(
      items: [],
      selectedIndex: null,
      isSpinning: false,
    ));
  }

  Future<void> _onLoadClassesFromAPI(
    LoadClassesFromAPI event,
    Emitter<SpinwheelState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final classes = await ClassRepository.getAllClasses();
      emit(state.copyWith(
        classes: classes,
        isLoading: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        error: 'Failed to load classes: $error',
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadStudentsFromClass(
    LoadStudentsFromClass event,
    Emitter<SpinwheelState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final students = await StudentRepository.getStudentsByClassId(event.classId);
      
      // Convert students to spinwheel items
      final items = students.map((student) => '${student.studentName} - ${student.idStudents}').toList();
      
      // Find the selected class in the classes list
      ClassModel? selectedClass;
      try {
        selectedClass = state.classes.firstWhere((c) => c.classesId == event.classId);
      } catch (e) {
        // If class not found in current list, create a temporary one or fetch it
        print('Class not found in current list: $event.classId');
        selectedClass = null;
      }
      
      emit(state.copyWith(
        items: items,
        selectedClass: selectedClass,
        isLoading: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        error: 'Failed to load students: $error',
        isLoading: false,
      ));
    }
  }

  Future<void> _onSaveWheelResult(
    SaveWheelResult event,
    Emitter<SpinwheelState> emit,
  ) async {
    try {
      await WheelRepository.saveWheelResult(
        result: event.winnerName,
        classId: event.classId,
      );
    } catch (error) {
      emit(state.copyWith(
        error: 'Failed to save wheel result: $error',
      ));
    }
  }

  @override
  Future<void> close() async {
    try {
      _selectedController.close();
    } catch (_) {}

    try {
      state.selectedController.close();
    } catch (_) {}
    return super.close();
  }
}