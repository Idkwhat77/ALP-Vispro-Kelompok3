import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info.dart';
import '../widgets/logout_button.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_event.dart';
import '../../bloc/profile_state.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun Anda?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1368CE),
            ),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              context.read<ProfileBloc>().add(LogoutPressed());
              Navigator.pop(context);
              context.go('/login'); 
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFE21B3C),
            ),
            child: const Text(
              "Keluar",
              style: TextStyle(color: Colors.white),
            ),
            child: const Text(
              "Keluar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profil",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/tools');
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF46178F),
                ),
              );
            }

            if (state.status == ProfileStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Terjadi kesalahan',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // FOTO PROFIL
                      ProfileAvatar(photoUrl: state.photoUrl),

                      const SizedBox(height: 32),

                      // INFO
                      ProfileTextInfo(
                        label: "Nama",
                        value: state.name.isNotEmpty ? state.name : '-',
                        icon: Icons.person,
                      ),

                      ProfileTextInfo(
                        label: "Alamat Email",
                        value: state.email.isNotEmpty ? state.email : '-',
                        icon: Icons.email,
                      ),

                      const SizedBox(height: 10),

                      // LOGOUT BUTTON 
                      LogoutButton(
                        onTap: () => _showLogoutDialog(context),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
