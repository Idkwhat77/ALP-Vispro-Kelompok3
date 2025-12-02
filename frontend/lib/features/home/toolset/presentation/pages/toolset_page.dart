import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  ];

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
            ),   
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),

        body: Column(
          children: [
            // AVATAR + TEACHER NAME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Kasmir Syariati",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Guru Informatika",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // TOOLSET CAROUSEL
            Expanded(
              child: BlocBuilder<ToolsetBloc, ToolsetState>(
                builder: (context, state) {
                  return PageView.builder(
                    controller: _pageController,
                    itemCount: toolsets.length,
                    itemBuilder: (context, index) {
                      final toolset = toolsets[index];

                      double scale = 1.0;
                      if (_pageController.position.haveDimensions) {
                        final currentPage = _pageController.page!;
                        scale = (1 - (currentPage - index).abs() * 0.2)
                            .clamp(0.85, 1.0);
                      }

                      final bool isSelected =
                          state is ToolsetSelected &&
                              state.selectedToolset.name == toolset.name;

                      return Transform.scale(
                        scale: scale,
                        child: GestureDetector(
                          onTap: () {
                            context.read<ToolsetBloc>().add(
                                  SelectToolsetEvent(toolset),
                                );
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
                                )
                              ],
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                width: isSelected ? 2.4 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  toolset.icon,
                                  size: 60,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  toolset.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
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
          ],
        ),
      ),
    );
  }
}
