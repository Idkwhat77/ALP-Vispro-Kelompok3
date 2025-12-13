import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CharadesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CharadesAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,

      // Back button (same as SpinWheel)
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/tools'),
      ),

      // Center title
      title: const Text(
        'Charades',
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),

      foregroundColor: Colors.black,
    );
  }
}
