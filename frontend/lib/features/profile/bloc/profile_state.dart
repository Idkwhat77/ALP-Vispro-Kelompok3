class ProfileState {
  final String name;
  final String email;
  final String photoUrl;

  ProfileState({
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory ProfileState.initial() => ProfileState(
        name: "",
        email: "",
        photoUrl: "",
      );
}
