import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/shared/widgets/custom_text_button_default.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          children: [
            // Page 1
            Container(
              color: Colors.red,
              child: const Center(child: Text('Page1')),
            ),
            // Page 2
            Container(
              color: Colors.yellow,
              child: const Center(child: Text('Page2')),
            ),
            // Page 3
            Container(
              color: Colors.green,
              child: const Center(child: Text('Page3')),
            ),
            // Page 4
            Container(
              color: Colors.blue,
              child: const Center(child: Text('Page4')),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TextButton for Skip
            CustomTextButton(text: 'Skip', onPressed: () {}),
            // For Smooth Page Indicator
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 4,
                effect: WormEffect(
                  spacing: 15,
                  dotColor: AppColors.semiDark,
                  activeDotColor: AppColors.primary,
                ),
              ),
            ),
            // TextButton for Next
            CustomTextButton(text: 'Next', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
