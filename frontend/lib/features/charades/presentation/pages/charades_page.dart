import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/charades/blocs/charades_event.dart';

import '../../blocs/charades_bloc.dart';
import '../widgets/charades_widget.dart';
import '../widgets/charades_app_bar.dart';

class CharadesPage extends StatefulWidget {
  const CharadesPage({super.key});

  @override
  State<CharadesPage> createState() => _CharadesPageState();
}

class _CharadesPageState extends State<CharadesPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharadesBloc()..add(LoadThemes()),
      child: const Scaffold(
        backgroundColor: Colors.white,
        appBar: const CharadesAppBar(),
        body: SafeArea(child: CharadesWidget()),
      ),
    );
  }
}
