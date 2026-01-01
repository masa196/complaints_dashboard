// lib/core/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool loading;
  final Color? color;
  final Color? textColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final TextStyle? textStyle;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.loading = false,
    this.color,
    this.textColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.textStyle,
    this.height = 48,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final Color effectiveBackground = color ?? theme.colorScheme.primary;
    final Color effectiveTextColor = textColor ?? Colors.white;
    final Color effectiveDisabledBackground = disabledBackgroundColor ?? Colors.grey.shade300;
    final Color effectiveDisabledText = disabledTextColor ?? Colors.grey.shade600;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackground,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: effectiveDisabledBackground,
          disabledForegroundColor: effectiveDisabledText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            // make progress indicator visible over background; prefer textColor
            valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
          ),
        )
            : _buildLabel(effectiveTextColor),
      ),
    );
  }

  Widget _buildLabel(Color fallbackColor) {

    if (textStyle != null) {
      return Text(
        label,
        style: textStyle!.copyWith(fontSize: textStyle!.fontSize ?? 16),
      );
    }
    return Text(
      label,
      style: GoogleFonts.notoSansArabic(
        fontSize: 16,
        color: textColor ?? fallbackColor,
      ),
    );
  }
}
