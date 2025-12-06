import 'package:flutter/material.dart';

class SpinButton extends StatelessWidget {
  final List<String> items;
  final bool isSpinning;
  final VoidCallback onSpin;

  const SpinButton({
    super.key,
    required this.items,
    required this.isSpinning,
    required this.onSpin,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = items.length <= 1 || isSpinning;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: disabled ? null : onSpin,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? Colors.grey[300] : const Color(0xFF46178F),
          foregroundColor: disabled ? Colors.grey[700] : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          disabled ? "SPIN" : (isSpinning ? "...Berputar" : "SPIN"),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
