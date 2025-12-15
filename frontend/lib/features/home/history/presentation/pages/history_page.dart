import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // ─────────────── Hardcoded mock data ───────────────
  final List<Map<String, dynamic>> sessions = [
    {
      'charadesTheme': {'name': 'Animals'},
      'played_at': '2025-12-15 10:30',
      'total_guess_correct': 7,
      'total_guess_skipped': 2,
    },
    {
      'charadesTheme': {'name': 'Movies'},
      'played_at': '2025-12-14 14:20',
      'total_guess_correct': 5,
      'total_guess_skipped': 3,
    },
    {
      'charadesTheme': {'name': 'Fruits'},
      'played_at': '2025-12-13 16:45',
      'total_guess_correct': 8,
      'total_guess_skipped': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Game History",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (sessions.isEmpty) {
      return const Center(
        child: Text("No games played yet", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _HistoryCard(session: session);
      },
    );
  }
}

// ─────────────────────────────────────────────
// HISTORY CARD
// ─────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> session;

  const _HistoryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFF46178F).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          _GameIcon(),
          const SizedBox(width: 16),
          Expanded(child: _SessionInfo(session: session)),
        ],
      ),
    );
  }
}

class _GameIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF46178F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.videogame_asset_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}

class _SessionInfo extends StatelessWidget {
  final Map<String, dynamic> session;

  const _SessionInfo({required this.session});

  @override
  Widget build(BuildContext context) {
    final themeName = session['charadesTheme']?['name'] ?? 'Charades';
    final playedAt = session['played_at']?.toString() ?? 'Unknown Date';
    final correct = session['total_guess_correct'] ?? 0;
    final skipped = session['total_guess_skipped'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          themeName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          "Played on $playedAt",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _StatChip(
              icon: Icons.check_circle,
              label: "$correct Correct",
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            _StatChip(
              icon: Icons.skip_next,
              label: "$skipped Skipped",
              color: Colors.orange,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
