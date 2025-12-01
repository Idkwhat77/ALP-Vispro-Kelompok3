import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/login_bloc.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LoginPage(),
        ),
      ),
    ),
  );
}
