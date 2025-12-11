import 'package:flutter/material.dart';

class SpinwheelHeader extends StatelessWidget {
  final VoidCallback onShuffle;
  final VoidCallback onClear;

  const SpinwheelHeader({
    super.key,
    required this.onShuffle,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Daftar Item",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              _squareBtn(Icons.shuffle, const Color(0xFFFFA602), onShuffle),
              const SizedBox(width: 8),
              _squareBtn(Icons.delete_forever, const Color(0xFFE21B3C), onClear),
            ],
          )
        ],
      ),
    );
  }

  Widget _squareBtn(IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      height: 40,
      width: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Icon(icon),
      ),
    );
  }
}
