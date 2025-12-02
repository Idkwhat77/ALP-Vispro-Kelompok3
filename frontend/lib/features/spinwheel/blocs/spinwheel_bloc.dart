import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'spinwheel_event.dart';
import 'spinwheel_state.dart';

class SpinwheelBloc extends Bloc<SpinwheelEvent, SpinwheelState> {
  final StreamController<int> _selectedController = StreamController<int>.broadcast();
  final Random _rnd = Random();

  SpinwheelBloc()
      : super(SpinwheelState(
          items: const [],
          selectedController: StreamController<int>.broadcast(), // placeholder, will replace below
        )) {
    emit(state.copyWith(selectedController: _selectedController));

    on<AddItem>(_onAddItem);
    on<RemoveItemAt>(_onRemoveItemAt);
    on<EditItem>(_onEditItem);
    on<ToggleRemoveOnSelect>(_onToggleRemoveOnSelect);
    on<ShuffleItems>(_onShuffleItems);
    on<LoadClass>(_onLoadClass);
    on<SpinWheel>(_onSpinWheel);
    on<FinishSpin>(_onFinishSpin);
    on<ClearItems>(_onClearItems);
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
    if (newItems.isEmpty) newSelected = null;
    else if (newSelected != null && newSelected >= newItems.length) newSelected = null;
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
    if (state.items.length < 1) return;
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
      if (newItems.isEmpty) newSelected = null;
      else if (newSelected != null && newSelected >= newItems.length) newSelected = null;
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