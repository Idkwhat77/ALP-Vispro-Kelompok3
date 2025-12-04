import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final Function(String) onChanged;

  const PasswordTextField({super.key, required this.onChanged});

  @override
  State<PasswordTextField> createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        obscureText: _obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Masukkan Password",
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        style: const TextStyle(fontFamily: 'Poppins'),
      ),
    );
  }
}
