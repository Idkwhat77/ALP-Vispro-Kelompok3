import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  
  const ProfileAvatar({super.key, this.photoUrl});

  // Fix the URL to use correct host based on platform
  String? _getFixedUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    
    // Replace localhost/127.0.0.1 with the correct host for the platform
    String fixedUrl = url;
    
    if (kIsWeb) {
      // For web, use the actual server IP
      fixedUrl = url.replaceAll('http://localhost:8000', 'http://192.168.56.1:8000')
                    .replaceAll('http://192.168.56.1:8000', 'http://192.168.56.1:8000');
    } else if (Platform.isAndroid) {
      // For Android emulator, use 10.0.2.2
      fixedUrl = url.replaceAll('http://localhost:8000', 'http://10.0.2.2:8000')
                    .replaceAll('http://192.168.56.1:8000', 'http://10.0.2.2:8000');
    }
    // iOS simulator and desktop can use localhost
    
    return fixedUrl;
  }

  @override
  Widget build(BuildContext context) {
    final fixedUrl = _getFixedUrl(photoUrl);
    
    return Center(
      child: CircleAvatar(
        radius: 80,
        backgroundColor: const Color(0xFF46178F),
        backgroundImage: (fixedUrl != null && fixedUrl.isNotEmpty)
            ? NetworkImage(fixedUrl)
            : null,
        onBackgroundImageError: (fixedUrl != null && fixedUrl.isNotEmpty)
            ? (_, __) {
                debugPrint('Failed to load profile image: $fixedUrl');
              }
            : null,
        child: (fixedUrl == null || fixedUrl.isEmpty)
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
