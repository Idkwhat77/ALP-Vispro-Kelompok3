import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/toolset_bloc.dart';
import '../../bloc/toolset_event.dart';
import '../../bloc/toolset_state.dart';
import '../../models/toolset_model.dart';

class ToolsetPage extends StatefulWidget {
  const ToolsetPage({super.key});

  @override
  State<ToolsetPage> createState() => _ToolsetPageState();
}

class _ToolsetPageState extends State<ToolsetPage> {
  final PageController _pageController = PageController(viewportFraction: 0.75);

  final List<ToolsetModel> toolsets = [
    ToolsetModel(name: "SpinWheel", icon: Icons.casino),
    ToolsetModel(name: "Charades", icon: Icons.theater_comedy),
    ToolsetModel(name: "Quiz (Coming Soon)", icon: Icons.quiz),
  ];

  // OPACITY khusus overlay Coming Soon 
  double comingSoonOpacity = 0.7;

  @override
  void initState() {
    super.initState();

    // update scale secara realtime
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ToolsetBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Toolset",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFF46178F),
                    child: Icon(Icons.person, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Kasmir Syariati",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 4),
                      Text("Guru Informatika",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Silahkan pilih tool yang ingin digunakan untuk aktivitas pembelajaran!",
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ===== TOOLSET CAROUSEL =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: BlocBuilder<ToolsetBloc, ToolsetState>(
                  builder: (context, state) {
                    return PageView.builder(
                      controller: _pageController,
                      itemCount: toolsets.length,
                      itemBuilder: (context, index) {
                        final toolset = toolsets[index];

                        // scale effect (smooth)
                        final page = _pageController.page ??
                            _pageController.initialPage.toDouble();
                        double distance = (page - index).abs();
                        double scale = (1 - distance * 0.15).clamp(0.85, 1.0);

                        final bool isSelected =
                            state is ToolsetSelected &&
                            state.selectedToolset.name == toolset.name;

                        return Transform.scale(
                          scale: scale,
                          child: GestureDetector(
                            onTap: () {
                              if (toolset.name == "Quiz (Coming Soon)") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Quiz feature is coming soon!"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }

                              context
                                  .read<ToolsetBloc>()
                                  .add(SelectToolsetEvent(toolset));

                              if (toolset.name == "SpinWheel") {
                                context.go('/spinwheel');
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 30),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.shade50
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: isSelected ? 14 : 6,
                                    offset: const Offset(0, 4),
                                    color: Colors.black12,
                                  ),
                                ],
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2.4 : 1,
                                ),
                              ),

                              // ===== CONTENT + OVERLAY =====
                              child: Stack(
                                children: [
                                  // ===== CONTENT =====
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Image.asset(
                                          toolset.name == "SpinWheel"
                                              ? 'assets/images/spinwheel.jpg'
                                              : toolset.name == "Charades"
                                                  ? 'assets/images/charades.jpg'
                                                  : 'assets/images/quiz_coming_soon.jpg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      Text(
                                        toolset.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          toolset.name == "SpinWheel"
                                              ? "Roda acak untuk memilih siswa atau topik."
                                              : toolset.name == "Charades"
                                                  ? "Permainan tebak kata seru dan menyenangkan untuk siswa."
                                                  : "Segera Hadir!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: toolset.name ==
                                                    "Quiz (Coming Soon)"
                                                ? Colors.orange
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // ===== OVERLAY COMING SOON =====
                                  if (toolset.name == "Quiz (Coming Soon)")
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300.withOpacity(0.6),
                                      highlightColor: Colors.grey.shade100.withOpacity(0.9),
                                      direction: ShimmerDirection.ltr,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
