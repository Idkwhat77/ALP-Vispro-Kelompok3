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

        // color theme adjusments
        color: const Color(0xFF46178F),
        buttonBackgroundColor: const Color(0xFF46178F),
        backgroundColor: Colors.white,
        //----------------------------------------------

        // smoother animation
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 400),


        height: 75,
        items: [
              Icon(
                Icons.history,
                size: 28,
                color: currentRoute.startsWith('/history')
                    ? Colors.white
                    : Colors.white,
              ),
              Icon(
                Icons.extension,
                size: 28,
                color: currentRoute.startsWith('/tools')
                    ? Colors.white
                    : Colors.white,
              ),
              Icon(
                Icons.people,
                size: 28,
                color: currentRoute.startsWith('/students')
                    ? Colors.white
                    : Colors.white,
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

  int _getIndexFromRoute(String route) {
    if (route.startsWith('/history')) return 0;
    if (route.startsWith('/tools')) return 1;
    if (route.startsWith('/students')) return 2;
    return 1; // default = tools
  }
}
