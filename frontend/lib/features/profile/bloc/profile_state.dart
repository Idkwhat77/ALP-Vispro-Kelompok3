import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String name;
  final String email;
  final String? photoUrl;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.name = '',
    this.email = '',
    this.photoUrl,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? email,
    String? photoUrl,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, name, email, photoUrl, errorMessage];
}
