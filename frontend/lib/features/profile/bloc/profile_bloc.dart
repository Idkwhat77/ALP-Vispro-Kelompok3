import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/auth_repository.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogoutPressed>(_onLogout);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    
    try {
      final teacher = await AuthRepository.getCurrentUser();
      
      if (teacher != null) {
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          username: teacher.username,
          specialization: teacher.specialist,
          name: teacher.fullname,
          email: teacher.email,
          photoUrl: teacher.pictureUrl,
        ));
      } else {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'Failed to load profile data',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Error: $e',
      ));
    }
  }

  Future<void> _onLogout(LogoutPressed event, Emitter<ProfileState> emit) async {
    await AuthRepository.logout();
  }
}
