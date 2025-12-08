import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogoutPressed>(_onLogout);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    // Dummy Data (ganti dengan data dari API/Local Storage)
    emit(ProfileState(
      name: "Kasmir Syariatii",
      email: "kasmir@example.com",
      photoUrl: "https://i.pravatar.cc/150",
    ));
  }

  void _onLogout(LogoutPressed event, Emitter<ProfileState> emit) {
    // Handle log out (hapus token, navigate, dll)
  }
}
