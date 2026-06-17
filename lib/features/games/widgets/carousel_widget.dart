import 'package:flutter/material.dart';

class GameCarousel extends StatefulWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext, int, dynamic) itemBuilder;
  final double height;
  final bool overlayIndicators;

  const GameCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height = 200,
    this.overlayIndicators = false,
  });

  @override
  State<GameCarousel> createState() => _GameCarouselState();
}

class _GameCarouselState extends State<GameCarousel> {
  late final PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: widget.overlayIndicators ? 1.0 : 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    Widget carousel = SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPageIndex = index),
        itemCount: widget.items.length,
        itemBuilder: (context, index) =>
            widget.itemBuilder(context, index, widget.items[index]),
      ),
    );

    Widget indicators = SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.8,
      child: Row(
        children: List.generate(
          widget.items.length,
              (index) =>
              Expanded(
                child: Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: _currentPageIndex == index ? Colors.white : Colors
                        .white24,
                  ),
                ),
              ),
        ),
      ),
    );

    if (widget.overlayIndicators) {
      return Stack(
        children: [
          carousel,
          Positioned(
              bottom: 10, left: 0, right: 0, child: Center(child: indicators)),
        ],
      );
    }

    return Column(
      children: [
        carousel,
        const SizedBox(height: 2),
        indicators,
      ],
    );
  }
}