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

  @override
  void initState() {
    super.initState();
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Silahkan pilih tool yang ingin digunakan untuk aktivitas pembelajaran!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: BlocBuilder<ToolsetBloc, ToolsetState>(
                  builder: (context, state) {
                    return PageView.builder(
                      controller: _pageController,
                      itemCount: toolsets.length,
                      itemBuilder: (context, index) {
                        final toolset = toolsets[index];

                        final page =
                            _pageController.page ??
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
                                  SnackBar(
                                    content: const Text(
                                      "Fitur Quiz akan segera hadir!",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              context.read<ToolsetBloc>().add(
                                SelectToolsetEvent(toolset),
                              );

                              if (toolset.name == "SpinWheel") {
                                context.go('/spinwheel');
                              } else if (toolset.name == "Charades") {
                                context.go('/charades');
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 30,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.shade50
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2.4 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: isSelected ? 14 : 6,
                                    offset: const Offset(0, 4),
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Image.asset(
                                      toolset.name == "SpinWheel"
                                          ? 'assets/images/spinwheel.jpg'
                                          : toolset.name == "Charades"
                                          ? 'assets/images/charades.jpg'
                                          : 'assets/images/quiz_coming_soon.jpg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    toolset.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      toolset.name == "SpinWheel"
                                          ? "Roda acak untuk memilih siswa."
                                          : toolset.name == "Charades"
                                          ? "Game tebak kata seru!"
                                          : "Segera hadir!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            toolset.name == "Quiz (Coming Soon)"
                                            ? Colors.orange
                                            : Colors.grey.shade600,
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
