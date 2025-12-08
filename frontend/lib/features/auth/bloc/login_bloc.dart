import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final loginResponse = await AuthRepository.login(state.email, state.password);
        
        if (loginResponse != null) {
          emit(state.copyWith(
            isLoading: false, 
            isSuccess: true,
            error: null,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            error: "Email atau password salah",
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          error: "Terjadi kesalahan: ${e.toString()}",
        ));
      }
    });
  }
}
