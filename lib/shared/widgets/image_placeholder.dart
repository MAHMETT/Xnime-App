import 'package:flutter/material.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';
import 'package:xnime_app/shared/widgets/custom_genre_button.dart';

class ImagePlaceholder extends StatelessWidget {
  final String imagePath;
  final String title;
  final List<String> genres;

  const ImagePlaceholder({
    super.key,
    required this.imagePath,
    required this.title,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imagePath, fit: BoxFit.cover),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.xxlBold),
              const SizedBox(height: 4),
              Row(
                // ganti Row ke Wrap biar bisa ke bawah kalau overflow
                spacing: 5,
                children:
                    genres.map((g) => CustomGenreButton(text: g)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
