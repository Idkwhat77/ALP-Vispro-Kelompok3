import 'package:flutter/material.dart';
import 'package:frontend/core/models/charades_theme.dart';

class CharadesIdle extends StatelessWidget {
  final List<CharadesTheme> themes;
  final void Function(int id, String name) onSelect;
  final List<Color> palette;

  const CharadesIdle({
    super.key,
    required this.themes,
    required this.onSelect,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pilih Tema',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: palette[4],
            ),
          ),
          const SizedBox(height: 18),

          // 🔲 GRID STARTS HERE
          GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: themes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // two columns
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.85, // controls card height
            ),
            itemBuilder: (context, i) {
              final t = themes[i];
              return GestureDetector(
                onTap: () => onSelect(t.id, t.name),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: palette[0].withOpacity(0.08),
                        blurRadius: 12,
                      ),
                    ],
                    border: Border.all(color: palette[3].withOpacity(0.12)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.category, size: 42, color: palette[3]),
                      const SizedBox(height: 12),
                      Text(
                        t.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Tap to select',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
