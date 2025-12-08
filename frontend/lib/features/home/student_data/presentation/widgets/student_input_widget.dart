import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/student_bloc.dart';
import '../../bloc/student_event.dart';
import '../../bloc/student_state.dart';

class StudentInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const StudentInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        final isClassEmpty = state.className.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Input Nama Siswa",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: !isClassEmpty,
                    decoration: InputDecoration(
                      hintText:
                          isClassEmpty ? "Input kelas dulu" : "Masukkan nama siswa",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: isClassEmpty
                      ? null
                      : () {
                          context.read<StudentBloc>().add(
                                AddStudentEvent(controller.text, 1), // Default class ID
                              );
                          controller.clear();
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: const Color(0xFF26890C),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(30, 55),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
