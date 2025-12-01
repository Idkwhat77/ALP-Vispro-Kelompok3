import 'package:flutter/material.dart';
import 'package:frontend/router/app_router.dart';

void main() {
  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    ),
  );
}
