import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 80,
        backgroundColor: Color(0xFF46178F),
        child: const Icon(
          Icons.person,
          size: 95,
          color: Colors.white,
        ),
      ),
    );
  }
}
