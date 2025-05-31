import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';

class Error404 extends StatelessWidget {
  const Error404({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/404.svg', width: 200),
          Text('Periksa koneksi internetmu.', style: AppTextStyles.smSemiBold),
        ],
      ),
    );
  }
}
