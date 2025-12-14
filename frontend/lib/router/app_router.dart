import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/bloc/login_bloc.dart';
import 'package:frontend/features/charades/blocs/charades_bloc.dart';
import 'package:frontend/features/charades/blocs/charades_event.dart';
import 'package:frontend/features/spinwheel/blocs/spinwheel_bloc.dart';
import 'package:frontend/features/spinwheel/presentation/pages/spinwheel_page.dart';
import 'package:go_router/go_router.dart';

import '../features/home/student_data/bloc/student_bloc.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/splash/bloc/splash_bloc.dart';
import '../widgets/main_scaffold.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/history/presentation/pages/history_page.dart';
import '../features/home/toolset/presentation/pages/toolset_page.dart';
import '../features/home/student_data/presentation/pages/student_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/charades/presentation/pages/charades_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',

  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SplashBloc(),
          child: const SplashPage(),
        );
      },
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => LoginBloc(),
          child: const LoginPage(),
        );
      },
    ),

    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),

    // SHELL ROUTE
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryPage(),
        ),
        GoRoute(
          path: '/tools',
          builder: (context, state) => const ToolsetPage(),
        ),
        GoRoute(
          path: '/students',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => StudentBloc(),
              child: StudentPage(),
            );
          },
        ),
      ],
    ),

    // SPINWHEEL
    GoRoute(
      path: '/spinwheel',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SpinwheelBloc(),
          child: const SpinwheelPage(),
        );
      },
    ),

    // CHARADES
    GoRoute(
      path: '/charades',
      builder: (context, state) => const CharadesPage(),
    ),
  ],
);
