import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Positioned(
                  left: 129,
                  top: 111,
                  child: Container(
                    width: 154,
                    height: 154,
                    decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 111,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/logo/clinter_logo_v1.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // TITLE
                Positioned(
                  left: 31,
                  top: 324,
                  child: Text(
                    'Masuk ke Akun Anda',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Atau
                Positioned(
                  left: 191,
                  top: 707,
                  child: const Text(
                    'Atau',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // EMAIL + PASSWORD FORM
                Positioned(
                  left: 34,
                  top: 375,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Alamat Email',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // Email Input
                          Container(
                            width: 343,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "guru@gmail.com",
                                hintStyle: TextStyle(fontFamily: 'Poppins'),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                              ),
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),

                          const SizedBox(height: 22),

                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // Password Input
                          Container(
                            width: 343,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(fontFamily: 'Poppins'),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                              ),
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),

                          const SizedBox(height: 22),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // GARIS PEMBATAS
                Positioned(
                  left: 34,
                  top: 716,
                  child: Container(
                    width: 139,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                    ),
                  ),
                ),
                Positioned(
                  left: 238,
                  top: 716,
                  child: Container(
                    width: 139,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                    ),
                  ),
                ),

                // LOGIN BUTTON
                Positioned(
                  left: 34,
                  top: 630,
                  child: Container(
                    width: 343,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF46178F),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Positioned(
                  left: 175,
                  top: 640,
                  child: SizedBox(
                    width: 61.39,
                    height: 30,
                    child: Text(
                      'Masuk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // LOGIN GOOGLE BUTTON
                Positioned(
                  left: 34,
                  top: 753,
                  child: Container(
                    width: 343,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  left: 80,
                  top: 763,
                  child: SizedBox(
                    width: 260,
                    height: 30,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/icon/google.svg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Masuk dengan Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
