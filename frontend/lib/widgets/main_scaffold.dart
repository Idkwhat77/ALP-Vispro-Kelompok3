import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: CurvedNavigationBar(
        index: _getIndexFromRoute(currentRoute),

        color: const Color(0xFF46178F),
        buttonBackgroundColor: const Color(0xFF864CBF),
        backgroundColor: Colors.white,

        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 400),

        height: 75,

        items: [
          _navIcon(
            selected: currentRoute.startsWith('/history'),
            icon: Icons.history,
          ),
          _navIcon(
            selected: currentRoute.startsWith('/tools'),
            icon: Icons.sports_esports,
          ),
          _navIcon(
            selected: currentRoute.startsWith('/students'),
            icon: Icons.people,
          ),
        ],

        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/history');
              break;
            case 1:
              context.go('/tools');
              break;
            case 2:
              context.go('/students');
              break;
          }
        },
      ),
    );
  }

  // SELECTED = tidak diberi padding
  // NON-SELECTED = diberi padding ke bawah
  Widget _navIcon({
    required bool selected,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: selected ? 0 : 15),
      child: Icon(
        icon,
        size: 40,
        color: selected ? Colors.white : Colors.white
      ),
    );
  }

  int _getIndexFromRoute(String route) {
    if (route.startsWith('/history')) return 0;
    if (route.startsWith('/tools')) return 1;
    if (route.startsWith('/students')) return 2;
    return 1;
  }
}
