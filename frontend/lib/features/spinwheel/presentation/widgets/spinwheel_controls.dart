import 'package:flutter/material.dart';
import 'package:frontend/services/class_generator.dart';

typedef OnAdd = void Function();
typedef OnLoadClass = void Function(String? value);
typedef OnToggleRemove = void Function(bool value);

class SpinwheelControls extends StatelessWidget {
  final TextEditingController controller;
  final bool removeOnSelect;
  final OnAdd onAdd;
  final OnLoadClass onLoadClass;
  final OnToggleRemove onToggleRemove;

  const SpinwheelControls({
    super.key,
    required this.controller,
    required this.removeOnSelect,
    required this.onAdd,
    required this.onLoadClass,
    required this.onToggleRemove,
  });

  @override
  Widget build(BuildContext context) {
    final classList = ClassGenerator.classList;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown kelas
          DropdownButtonFormField<String>(
            isExpanded: true,
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal:12, vertical: 10),
            ),
            hint: const Text("Pilih kelas"),
            onChanged: onLoadClass,
            items: classList
                .map((k) => DropdownMenuItem(
                      value: k,
                      child: Text(k),
                    ))
                .toList(),
          ),

          const SizedBox(height: 12),

          // Input + Add button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Tambah item',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                width: 48,
                child: ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26890C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Toggle removeOnSelect
          Row(
            children: [
              Switch(
                value: removeOnSelect,
                onChanged: onToggleRemove,
                activeThumbColor: const Color(0xFF1368CE),
                activeTrackColor: Colors.blue.shade100,
                inactiveThumbColor: Colors.grey.shade500,
                inactiveTrackColor: Colors.grey.shade50,
              ),
              const SizedBox(width: 8),
              const Text("Hapus item setelah terpilih"),
            ],
          ),
        ],
      ),
    );
  }
}
