import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final File? localImage;
  final VoidCallback? onEditTap;
  final bool isLoading;
  
  const ProfileAvatar({
    super.key, 
    this.photoUrl,
    this.localImage,
    this.onEditTap,
    this.isLoading = false,
  });

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

  ImageProvider? _getImageProvider() {
    // Priority: local image > network image
    if (localImage != null) {
      return FileImage(localImage!);
    }
    
    final fixedUrl = _getFixedUrl(photoUrl);
    if (fixedUrl != null && fixedUrl.isNotEmpty) {
      return NetworkImage(fixedUrl);
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final fixedUrl = _getFixedUrl(photoUrl);
    final imageProvider = _getImageProvider();
    
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: const Color(0xFF46178F),
            backgroundImage: imageProvider,
            onBackgroundImageError: (fixedUrl != null && fixedUrl.isNotEmpty && localImage == null)
                ? (_, __) {
                    debugPrint('Failed to load profile image: $fixedUrl');
                  }
                : null,
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  )
                : (imageProvider == null)
                    ? const Icon(
                        Icons.person,
                        size: 95,
                        color: Colors.white,
                      )
                    : null,
          ),
          // Edit icon button
          if (onEditTap != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: isLoading ? null : onEditTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF46178F),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}