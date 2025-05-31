import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xnime_app/shared/layout/home_content.dart';
import 'package:xnime_app/shared/widgets/banner_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController pageController;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [BannerSlider(), const SizedBox(height: 5), HomeContent()],
        ),
      ),
    );
  }
}
