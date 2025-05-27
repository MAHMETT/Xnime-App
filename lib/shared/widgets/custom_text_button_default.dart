import 'package:flutter/material.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';

class CustomTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle textStyle;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.backgroundColor = AppColors.semiDark,
    this.textColor = AppColors.light,
    this.borderRadius = 8.0,
    this.textStyle = AppTextStyles.normalSemiBold,
    this.width,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  bool _isHovered = false;

  int _opacityToAlpha(double opacity) =>
      (opacity.clamp(0.0, 1.0) * 255).round();

  @override
  Widget build(BuildContext context) {
    final bgColor =
        _isHovered
            ? widget.backgroundColor.withAlpha(_opacityToAlpha(0.8))
            : widget.backgroundColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          alignment: Alignment.center,
          width: widget.width,
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Text(widget.text, style: widget.textStyle),
        ),
      ),
    );
  }
}
