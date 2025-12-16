import 'package:equatable/equatable.dart';
import 'dart:io';

enum ProfileStatus { initial, loading, loaded, error, uploading }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String name;
  final String username;
  final String specialization;
  final String email;
  final String? photoUrl;
  final String? errorMessage;
  final File? localImage;
  final int? teacherId;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.name = '',
    this.username = '',
    this.specialization = '',
    this.email = '',
    this.photoUrl,
    this.errorMessage,
    this.localImage,
    this.teacherId,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? username,
    String? specialization,
    String? email,
    String? photoUrl,
    String? errorMessage,
    File? localImage,
    int? teacherId,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      username: username ?? this.username,
      specialization: specialization ?? this.specialization,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      localImage: localImage ?? this.localImage,
      teacherId: teacherId ?? this.teacherId,
    );
  }

  @override
  List<Object?> get props => [status, name, username, specialization, email, photoUrl, errorMessage, localImage, teacherId];
}
