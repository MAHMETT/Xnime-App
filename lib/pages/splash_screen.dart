import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef InitCallback = FutureOr<void> Function();

class SplashScreen extends StatefulWidget {
  final Duration duration;
  final String logo;
  final InitCallback onInitComplete;

  const SplashScreen({
    super.key,
    this.duration = const Duration(seconds: 2),
    this.logo = 'lib/assets/logos/Xyutori.svg',
    required this.onInitComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay then call callback (ex: navigate)
    Future.delayed(widget.duration, () async {
      await widget.onInitComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(widget.logo, width: 100, height: 114.6),
      ),
    );
  }
}
