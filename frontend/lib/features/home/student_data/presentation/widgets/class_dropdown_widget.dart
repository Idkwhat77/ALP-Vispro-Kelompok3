import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/models/class.dart';
import '../../bloc/student_bloc.dart';
import '../../bloc/student_event.dart';
import '../../bloc/student_state.dart';

class ClassDropdownWidget extends StatelessWidget {
  const ClassDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Kelas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black),
              ),
              child: DropdownButton<ClassModel>(
                dropdownColor: Colors.white,
                value: state.selectedClass,
                hint: const Text("Pilih kelas..."),
                isExpanded: true,
                underline: const SizedBox(),
                items: state.classes
                    .map(
                      (cls) => DropdownMenuItem(
                        value: cls,
                        child: Text(cls.className),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<StudentBloc>().add(SelectClassEvent(value));
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
