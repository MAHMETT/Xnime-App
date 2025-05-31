import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';

class TitleSeeAll extends StatelessWidget {
  final String title;
  final String goTo;

  const TitleSeeAll({super.key, required this.goTo, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.xlSemiBold),
        GestureDetector(
          onTap: () {
            context.push(goTo);
          },
          child: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              children: [
                Text('See All', style: AppTextStylesPrimary.smSemiBold),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
