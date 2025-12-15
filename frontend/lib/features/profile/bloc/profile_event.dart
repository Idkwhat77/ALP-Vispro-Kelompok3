import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class LogoutPressed extends ProfileEvent {}

class UpdateProfilePicture extends ProfileEvent {
  final File imageFile;

  const UpdateProfilePicture(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}
