import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/login_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/main_scaffold.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/history_page.dart';
import '../features/home/presentation/pages/toolset_page.dart';
import '../features/home/presentation/pages/student_data_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  routes: [
    // ---------- LOGIN ROUTE ----------
    GoRoute(
    path: '/login',
    builder: (context, state) {
      return BlocProvider(
        create: (_) => LoginBloc(),
        child: const LoginPage(),
      );
    },
  ),

    // ---------- MAIN SHELL ROUTE ----------
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
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
          builder: (context, state) => const StudentDataPage(),
        ),
      ],
    ),
  ],
);
