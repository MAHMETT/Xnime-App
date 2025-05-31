import 'package:flutter/material.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';

class AnimeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? episodes;

  const AnimeCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.episodes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imagePath, fit: BoxFit.cover),
                ),
              ),
              if (episodes != null && episodes!.isNotEmpty)
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('Ep $episodes', style: AppTextStyles.xs),
                  ),
                ),
            ],
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
