import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';

import '../../blocs/spinwheel_bloc.dart';
import '../../blocs/spinwheel_event.dart';
import '../../blocs/spinwheel_state.dart';

import '../helpers/spinwheel_dialog_helper.dart';
import '../widgets/spinwheel_header.dart';
import '../widgets/spinwheel_item_list.dart';
import '../widgets/spinwheel_widget.dart';
import '../widgets/spinwheel_controls.dart';
import '../widgets/spin_button.dart';
import '../widgets/selected_dialog.dart';
import '../../../../core/models/class.dart';

class SpinwheelPage extends StatefulWidget {
  const SpinwheelPage({super.key});

  @override
  State<SpinwheelPage> createState() => _SpinwheelPageState();
}

class _SpinwheelPageState extends State<SpinwheelPage> {
  final TextEditingController _controller = TextEditingController();
  late ConfettiController _confetti;
  StreamSubscription<int>? _selectedSub;

  int? _lastSelectedIndex;
  String? _lastSelectedName;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<SpinwheelBloc>();

      _selectedSub = bloc.selectedStream.listen((index) {
        final items = bloc.state.items;

        if (index >= 0 && index < items.length) {
          _lastSelectedName = items[index];
        } else {
          _lastSelectedName = null;
        }

        _lastSelectedIndex = index;
      });
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    _selectedSub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onAdd() {
    final t = _controller.text.trim();
    if (t.isEmpty) return;

    context.read<SpinwheelBloc>().add(AddItem(t));
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _onShuffle() => context.read<SpinwheelBloc>().add(const ShuffleItems());
  
  void _onLoadClass(ClassModel? selectedClass) {
    if (selectedClass == null) return;
    context.read<SpinwheelBloc>().add(LoadStudentsFromClass(selectedClass.classesId));
  }

  void _onToggleRemove(bool v) =>
      context.read<SpinwheelBloc>().add(ToggleRemoveOnSelect(v));

  void _onSpin() => context.read<SpinwheelBloc>().add(const SpinWheel());

  // When the spin animation ends
  void _onAnimationEnd() {
    final bloc = context.read<SpinwheelBloc>();
    final idx = _lastSelectedIndex ?? -1;

    bloc.add(FinishSpin(idx));

    final name = _lastSelectedName ?? 'Item $idx';

    showWinnerDialogWithConfetti(
      context: context,
      name: name,
      controller: _confetti,
    );

    // Extract winner information and save result
    if (_lastSelectedName != null && bloc.state.selectedClass != null) {
      final parts = _lastSelectedName!.split(' - ');
      if (parts.length >= 2) {
        final winnerName = parts[0];
        
        bloc.add(SaveWheelResult(
          winnerName: winnerName,
          classId: bloc.state.selectedClass!.classesId,
        ));
      }
    }

    _lastSelectedIndex = null;
    _lastSelectedName = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpinWheel'),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tools'),
        ),
      ),

      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: BlocBuilder<SpinwheelBloc, SpinwheelState>(
            builder: (context, state) {
              final items = state.items;
              final bloc = context.read<SpinwheelBloc>();

            // Show error message if any
            if (state.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Controls row
                 SpinwheelControls(
                  controller: _controller,
                  removeOnSelect: state.removeOnSelect,
                  onAdd: () => context.read<SpinwheelBloc>().add(AddItem(_controller.text)),
                  onLoadClass: (classModel) {
                    context.read<SpinwheelBloc>().add(
                      LoadStudentsFromClass(classModel!.classesId),
                    );
                  },
                  onToggleRemove: (value) {
                    context.read<SpinwheelBloc>().add(ToggleRemoveOnSelect(value));
                  },
                  classes: state.classes,
                  selectedClass: state.selectedClass, 
                  isLoading: state.isLoading,
                ),


                  const SizedBox(height: 12),

                  // Spin wheel
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: SizedBox(
                        width: 360,
                        child: SpinwheelWidget(
                          items: items,
                          selectedStream: bloc.selectedStream,
                          onAnimationEnd: _onAnimationEnd,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Spin button
                  SpinButton(
                    items: items,
                    isSpinning: state.isSpinning,
                    onSpin: _onSpin,
                  ),

                  const SizedBox(height: 12),

                  // List header (Daftar Item + Icon buttons)
                  SpinwheelHeader(
                    onShuffle: _onShuffle,
                    onClear: () => bloc.add(const ClearItems()),
                  ),

                  // Item List
                  Expanded(
                    flex: 1,
                    child: SpinwheelItemList(items: items),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
