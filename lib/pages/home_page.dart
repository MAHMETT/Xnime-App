import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xnime_app/shared/widgets/image_placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<Map<String, dynamic>> imageData = [
  {
    "path": "assets/images/boruto.jpg",
    "title": "Boruto",
    "genres": ["Action", "Adventure"],
  },
  {
    "path": "assets/images/one_piece.jpeg",
    "title": "One Piece",
    "genres": ["Adventure", "Fantasy"],
  },
  {
    "path": "assets/images/one_punch_man.jpg",
    "title": "One Punch Man",
    "genres": ["Comedy", "Action"],
  },
];

late List<Widget> _pages;
Timer? timer;
final PageController pageController = PageController(initialPage: 0);

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.8,
            child: PageView.builder(
              controller: pageController,
              itemCount: _pages.length,
              itemBuilder: (context, index) => _pages[index],
            ),
          ),
        ],
      ),
    );
  }
}
