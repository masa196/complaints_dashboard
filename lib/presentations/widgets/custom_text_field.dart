// lib/core/widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final ValueNotifier<bool>? obscureNotifier;
  final bool enabled;
  final Color focusedBorderColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    required this.prefixIcon,
    this.obscureNotifier,
    this.enabled = true,
    this.focusedBorderColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final _obscureNotifier = obscureNotifier ?? ValueNotifier<bool>(obscure);

    return ValueListenableBuilder<bool>(
      valueListenable: _obscureNotifier,
      builder: (context, isObscure, _) {
        return TextField(
          enabled: enabled,
          controller: controller,
          obscureText: isObscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            suffixIcon: obscure
                ? IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: enabled
                  ? () {
                _obscureNotifier.value = !isObscure;
              }
                  : null,
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              BorderSide(color: focusedBorderColor, width: 2),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        );
      },
    );
  }
}
