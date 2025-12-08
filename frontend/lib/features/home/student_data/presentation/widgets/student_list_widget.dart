import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/student_bloc.dart';
import '../../bloc/student_event.dart';
import '../../bloc/student_state.dart';

class StudentListWidget extends StatelessWidget {
  const StudentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          final bloc = context.read<StudentBloc>();

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: state.students.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada list",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.separated(
                    itemCount: state.students.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final student = state.students[index];

                      return ListTile(
                        title: Text(student.studentName),
                        contentPadding: EdgeInsets.zero,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () async {
                                final controller =
                                    TextEditingController(text: student.studentName);

                                final newValue = await showDialog<String?>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Edit Nama Siswa"),
                                    content: TextField(
                                      controller: controller,
                                      autofocus: true,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, null),
                                        child: const Text("Batal"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(
                                            ctx, controller.text),
                                        child: const Text("Simpan"),
                                      ),
                                    ],
                                  ),
                                );

                                if (newValue != null &&
                                    newValue.trim().isNotEmpty) {
                                  bloc.add(
                                    EditStudentEvent(
                                      studentId: student.idStudents,
                                      newName: newValue.trim(),
                                      classId: student.classesId,
                                    ),
                                  );
                                }
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  bloc.add(DeleteStudentEvent(index)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
