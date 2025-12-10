import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartAnimation>((event, emit) {
      // mulai dots animating
      emit(SplashDotsAnimating());
    });

    on<DotsMerged>((event, emit) async {
      // dots selesai → masuk morphing
      emit(SplashMorphing());
    });

    on<AnimationFinished>((event, emit) async {
      // morph ke logo + text selesai → done
      emit(SplashCompleted());
    });
  }
}
