import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';

class AnimeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? episodes;
  final String? status;
  final String? rating;
  final String animeId;

  const AnimeCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.episodes,
    this.rating,
    this.status,
    required this.animeId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/anime/$animeId');
      },
      child: SizedBox(
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
                if (rating != null && rating!.isNotEmpty)
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
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 15, color: Colors.amber[600]),
                          const SizedBox(width: 5),
                          Text('$rating', style: AppTextStyles.xs),
                        ],
                      ),
                    ),
                  ),
                if (status != null && status!.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            status!.toLowerCase() == 'ongoing'
                                ? Colors.amber[700]
                                : AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text('$status', style: AppTextStyles.xsSemiBold),
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
      ),
    );
  }
}
