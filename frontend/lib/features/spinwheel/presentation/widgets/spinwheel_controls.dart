import 'package:flutter/material.dart';
import '../../../../services/class_generator.dart';


typedef OnAdd = void Function();
typedef OnShuffle = void Function();
typedef OnLoadClass = void Function(String? key);
typedef OnToggleRemove = void Function(bool v);
typedef OnClearAll = void Function();

class SpinwheelControls extends StatelessWidget {
  final TextEditingController controller;
  final bool removeOnSelect;
  final OnAdd onAdd;
  final OnShuffle onShuffle;
  final OnLoadClass onLoadClass;
  final OnToggleRemove onToggleRemove;
  final OnClearAll onClearAll; 

  const SpinwheelControls({
    Key? key,
    required this.controller,
    required this.removeOnSelect,
    required this.onAdd,
    required this.onShuffle,
    required this.onLoadClass,
    required this.onToggleRemove,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classList = ClassGenerator.classList;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [ BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,3)) ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input + add icon
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Tambah item',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,   
                      ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48, width: 48,
                child: ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26890C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Dropdown (left) + Shuffle (right)
          Row(
            children: [
              Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,                     
                dropdownColor: Colors.white,         
                iconEnabledColor: Colors.grey[700],  
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,       
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                hint: const Text('Pilih kelas'),
                style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,  
                      fontFamily: 'Poppins', 
                      ),
                initialValue: null,
                onChanged: onLoadClass,
                items: classList
                    .map((k) => DropdownMenuItem(
                          value: k,
                          child: Text(k),
                        ))
                    .toList(),
              ),
            ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48, width: 48,
                child: ElevatedButton(
                  onPressed: onShuffle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA602),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.shuffle),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Toggle + Delete All on the right
          Row(
          children: [
            // Left: Toggle
            Switch(
              value: removeOnSelect,
              onChanged: onToggleRemove,
              activeThumbColor: const Color(0xFF1368CE),       // Warna knob saat ON
              activeTrackColor: Colors.blue.shade100,     // Warna track saat ON
              inactiveThumbColor: Colors.grey.shade500,   // Warna knob saat OFF
              inactiveTrackColor: Colors.grey.shade50,   // Warna track saat OFF
            ),
            const SizedBox(width: 8),
            const Text("Hapus item setelah terpilih"),

            Spacer(),

            // Right: Delete All button
            SizedBox(
              height: 48, width: 48,
              child: ElevatedButton(
                onPressed: onClearAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE21B3C), 
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.delete_forever),
              ),
            ),
          ],
        ),
        ],
      ),
    );
  }
}
