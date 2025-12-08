import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/spinwheel_bloc.dart';
import '../../blocs/spinwheel_event.dart';

class SpinwheelItemList extends StatelessWidget {
  final List<String> items;

  const SpinwheelItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SpinwheelBloc>();

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada item',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, idx) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: ListTile(
            title: Text(items[idx]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    final old = items[idx];
                    final newValue = await _showEditDialog(context, old);
                    if (newValue != null && newValue.isNotEmpty) {
                      bloc.add(EditItem(index: idx, newValue: newValue));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => bloc.add(RemoveItemAt(idx)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String old) async {
    final ctrl = TextEditingController(text: old);

    return await showDialog<String?>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, ctrl.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
