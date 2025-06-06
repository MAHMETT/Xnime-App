import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xnime_app/shared/widgets/image_placeholder.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

final List<Map<String, dynamic>> imageData = [
  {
    "path": "assets/images/boruto.jpg",
    "title": "Boruto",
    "genres": ["Action", "Adventure"],
    "animeId": "borot-sub-indo",
  },
  {
    "path": "assets/images/one_piece.jpeg",
    "title": "One Piece",
    "genres": ["Adventure", "Fantasy"],
    "animeId": "1piece-sub-indo",
  },
  {
    "path": "assets/images/one_punch_man.jpg",
    "title": "One Punch Man",
    "genres": ["Comedy", "Action"],
    "animeId": "punch-man-season-2-subtitle-indonesia",
  },
];

late List<Widget> _pages;
Timer? timer;
final PageController pageController = PageController(initialPage: 0);

class _BannerSliderState extends State<BannerSlider> {
  late final PageController pageController;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    _pages = List.generate(imageData.length, (index) {
      final item = imageData[index];
      return ImagePlaceholder(
        imagePath: item["path"],
        title: item["title"],
        genres: List<String>.from(item["genres"]),
        animeId: item["animeId"],
      );
    });
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.page == imageData.length - 1) {
        pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.8,
      child: PageView.builder(
        controller: pageController,
        itemCount: _pages.length,
        itemBuilder: (context, index) => _pages[index],
      ),
    );
  }
}
