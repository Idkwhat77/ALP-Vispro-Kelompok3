import 'package:flutter/material.dart';
import '../widgets/class_dropdown_widget.dart';
import '../widgets/student_list_widget.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Data Siswa",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600, 
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ClassDropdownWidget(),
            SizedBox(height: 20),
            StudentListWidget(),
          ],
        ),
      ),
    );
  }
}
