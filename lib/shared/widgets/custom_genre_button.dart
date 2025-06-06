import 'package:flutter/material.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';

class CustomGenreButton extends StatefulWidget {
  final String text;
  // final VoidCallback onPressed;
  // final double? width;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle textStyle;

  const CustomGenreButton({
    super.key,
    required this.text,
    // required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    this.backgroundColor = AppColors.semiDark,
    this.textColor = AppColors.light,
    this.borderRadius = 10,
    this.textStyle = AppTextStyles.xsSemiBold,
    // this.width,
  });

  @override
  State<CustomGenreButton> createState() => _CustomGenreButtonState();
}

class _CustomGenreButtonState extends State<CustomGenreButton> {
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
        // onTap: widget.onPressed,
        child: AnimatedContainer(
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
