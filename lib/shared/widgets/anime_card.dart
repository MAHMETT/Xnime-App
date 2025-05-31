import 'package:flutter/material.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';

class AnimeCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const AnimeCard({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: AppTextStyles.xs,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
