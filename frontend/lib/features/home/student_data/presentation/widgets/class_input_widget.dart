import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/student_bloc.dart';
import '../../bloc/student_event.dart';
import '../../bloc/student_state.dart';

class ClassInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const ClassInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Input Kelas",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 6),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Masukkan nama kelas",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            ElevatedButton(
              onPressed: () {
                context.read<StudentBloc>().add(
                      SaveClassEvent(controller.text),
                    );
                controller.clear();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color(0xFF26890C),
                foregroundColor: Colors.white,
                minimumSize: const Size(80, 55),
              ),
              child: const Text("Simpan"),
            ),
          ],
        ),

        const SizedBox(height: 8),

        BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            return Text(
              "Kelas tersimpan: ${state.className.isEmpty ? '(Belum ada)' : state.className}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    state.className.isEmpty ? Colors.grey : const Color(0xFF26890C),
              ),
            );
          },
        ),
      ],
    );
  }
}
