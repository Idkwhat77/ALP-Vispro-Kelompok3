import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/spinwheel_bloc.dart';
import '../../blocs/spinwheel_event.dart';
import '../../blocs/spinwheel_state.dart';
import '../widgets/spinwheel_widget.dart';
import '../widgets/spinwheel_controls.dart';
import '../widgets/spin_button.dart';
import '../widgets/selected_dialog.dart';
import '../../../../services/class_generator.dart';

class SpinwheelPage extends StatefulWidget {
  const SpinwheelPage({Key? key}) : super(key: key);

  @override
  State<SpinwheelPage> createState() => _SpinwheelPageState();
}

class _SpinwheelPageState extends State<SpinwheelPage> {
  final TextEditingController _controller = TextEditingController();
  StreamSubscription<int>? _selectedSub;
  int? _lastSelectedIndex;
  String? _lastSelectedName;
  late final Map<String, List<String>> _classMap;

  @override
  void initState() {
    super.initState();
    _classMap = ClassGenerator.buildAll();
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
  void _onLoadClass(String? key) {
    if (key == null) return;
    final items = _classMap[key] ?? [];
    context.read<SpinwheelBloc>().add(LoadClass(items));
  }

  void _onToggleRemove(bool v) =>
      context.read<SpinwheelBloc>().add(ToggleRemoveOnSelect(v));
  void _onSpin() => context.read<SpinwheelBloc>().add(const SpinWheel());

  void _onAnimationEnd() {
    final bloc = context.read<SpinwheelBloc>();
    final idx = _lastSelectedIndex ?? -1;
    bloc.add(FinishSpin(idx));

    final name = _lastSelectedName ?? 'Item $idx';
    showDialog(context: context, builder: (_) => SelectedDialog(name: name));

    _lastSelectedIndex = null;
    _lastSelectedName = null;
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Spinwheel'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.go('/tools');

        },
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Controls card
                  SpinwheelControls(
                    controller: _controller,
                    removeOnSelect: state.removeOnSelect,
                    onAdd: _onAdd,
                    onLoadClass: _onLoadClass,
                    onToggleRemove: _onToggleRemove,
                  ),

                  const SizedBox(height: 12),

                  // Wheel
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

                  // Spin Button
                  SpinButton(
                    items: items,
                    isSpinning: state.isSpinning,
                    onSpin: _onSpin,
                  ),

                  const SizedBox(height: 12),

                  // Header Daftar Item
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daftar Item",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),

                        Row(
                          children: [
                            // SHUFFLE
                            SizedBox(
                              height: 40, width: 40,
                              child: ElevatedButton(
                                onPressed: _onShuffle,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFA602),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Icon(Icons.shuffle),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // CLEAR ALL
                            SizedBox(
                              height: 40, width: 40,
                              child: ElevatedButton(
                                onPressed: () => bloc.add(const ClearItems()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE21B3C),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Icon(Icons.delete_forever),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // List Item
                  Expanded(
                    flex: 1,
                    child: items.isEmpty
                        ? Center(
                            child: Text(
                              'Belum ada item',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        : ListView.separated(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, idx) {
                              return Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 4),
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(items[idx]),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // EDIT
                                      IconButton(
                                        icon: const Icon(
                                            Icons.edit_outlined),
                                        onPressed: () async {
                                          final old =
                                              bloc.state.items[idx];
                                          final newValue =
                                              await showDialog<String?>(
                                            context: context,
                                            builder: (c) {
                                              final ctrl =
                                                  TextEditingController(
                                                      text: old);
                                              return AlertDialog(
                                                title: const Text(
                                                    'Edit Item'),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                content: TextField(
                                                  controller: ctrl,
                                                  autofocus: true,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(c),
                                                    style: TextButton
                                                        .styleFrom(
                                                      minimumSize:
                                                          const Size(
                                                              70, 40),
                                                      backgroundColor:
                                                          const Color(
                                                              0xFFE21B3C),
                                                      foregroundColor:
                                                          Colors.white,
                                                       shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8), 
                                                      ),
                                                    ),
                                                    child:
                                                        const Text('Batal'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            c,
                                                            ctrl.text
                                                                .trim()),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize:
                                                          const Size(
                                                              80, 40),
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF26890C),
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8), 
                                                      ),
                                                    ),
                                                    child: const Text(
                                                        'Simpan'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (newValue != null &&
                                              newValue.isNotEmpty) {
                                            bloc.add(
                                              EditItem(
                                                index: idx,
                                                newValue: newValue,
                                              ),
                                            );
                                          }
                                        },
                                      ),

                                      // DELETE
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline),
                                        onPressed: () => bloc.add(
                                            RemoveItemAt(idx)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
