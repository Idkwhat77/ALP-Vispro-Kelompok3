import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/student_bloc.dart';
import '../../bloc/student_state.dart';
import '../widgets/class_input_widget.dart';
import '../widgets/student_input_widget.dart';
import '../widgets/student_list_widget.dart';

class StudentPage extends StatelessWidget {
  StudentPage({super.key});

  final TextEditingController classController = TextEditingController();
  final TextEditingController studentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentBloc, StudentState>(
      listenWhen: (p, c) => p.className != c.className,
      listener: (context, state) {
        if (state.className.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Kelas '${state.className}' berhasil disimpan!"),
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Data Siswa"),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClassInputWidget(controller: classController),
              const SizedBox(height: 24),

              StudentInputWidget(controller: studentController),
              const SizedBox(height: 26),

              const Text("List Nama Siswa",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              const SizedBox(height: 6),

              const StudentListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
