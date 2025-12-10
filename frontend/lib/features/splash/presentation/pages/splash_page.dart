import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/splash_dots.dart';
import '../widgets/splash_logo.dart';
import '../widgets/splash_text.dart';
import '../widgets/splash_particles.dart';
import '../../bloc/splash_bloc.dart';
import '../../bloc/splash_state.dart';
import '../../bloc/splash_event.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController dotsController;
  late AnimationController morphController;

  late Animation<double> mergeProgress;
  late Animation<double> dotsFadeOut;
  late Animation<double> logoFadeIn;
  late Animation<double> logoScale;
  late Animation<double> textOpacity;

  late Animation<Color?> dotColor1;
  late Animation<Color?> dotColor2;
  late Animation<Color?> dotColor3;
  late Animation<Color?> dotColor4;

  List<Widget> particles = [];

  final Color clinterRed = const Color(0xFFE21B3C);
  final Color clinterYellow = const Color(0xFFFFA602);
  final Color clinterGreen = const Color(0xFF26890C);
  final Color clinterBlue = const Color(0xFF1368CE);

  @override
  void initState() {
    super.initState();

    dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    mergeProgress = CurvedAnimation(
      parent: dotsController,
      curve: Curves.easeOutQuad,
    );

    dotsController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<SplashBloc>().add(DotsMerged());
      }
    });

    morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    dotsFadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: morphController,
        curve: const Interval(0.0, 0.45),
      ),
    );

    dotColor1 = ColorTween(begin: clinterRed, end: Colors.white)
        .animate(morphController);
    dotColor2 = ColorTween(begin: clinterYellow, end: Colors.white)
        .animate(morphController);
    dotColor3 = ColorTween(begin: clinterGreen, end: Colors.white)
        .animate(morphController);
    dotColor4 = ColorTween(begin: clinterBlue, end: Colors.white)
        .animate(morphController);

    logoFadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: morphController, curve: const Interval(0.1, 0.75)),
    );

    logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: morphController, curve: const Interval(0.1, 0.75)),
    );

    textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: morphController, curve: const Interval(0.65, 1.0)),
    );

    morphController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<SplashBloc>().add(AnimationFinished());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashBloc>().add(StartAnimation());
      dotsController.forward();
    });
  }

  @override
  void dispose() {
    dotsController.dispose();
    morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashMorphing) {
          spawnParticles();
          morphController.forward();
        }

        if (state is SplashCompleted) {
          Future.delayed(const Duration(milliseconds: 350), () {
            if (mounted) context.go('/login');
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([dotsController, morphController]),
                builder: (_, __) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SplashDots(
                            mergeProgress: mergeProgress,
                            fadeOut: dotsFadeOut,
                            dotColor1: dotColor1.value!,
                            dotColor2: dotColor2.value!,
                            dotColor3: dotColor3.value!,
                            dotColor4: dotColor4.value!,
                          ),

                          SplashLogo(
                            opacity: logoFadeIn.value,
                            scale: logoScale.value,
                          ),
                        ],
                      ),

                      SplashText(opacity: textOpacity.value),
                    ],
                  );
                },
              ),
            ),

            ...particles,
          ],
        ),
      ),
    );
  }

  void spawnParticles() {
    final center = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );

    setState(() {
      particles = List.generate(
        6,
        (_) => SplashParticles(startOffset: center),
      );
    });
  }
}
