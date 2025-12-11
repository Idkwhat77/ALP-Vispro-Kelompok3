import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  
  const ProfileAvatar({super.key, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 80,
        backgroundColor: const Color(0xFF46178F),
        backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
            ? NetworkImage(photoUrl!)
            : null,
        onBackgroundImageError: (photoUrl != null && photoUrl!.isNotEmpty)
            ? (_, __) {}
            : null,
        child: (photoUrl == null || photoUrl!.isEmpty)
            ? const Icon(
                Icons.person,
                size: 95,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
