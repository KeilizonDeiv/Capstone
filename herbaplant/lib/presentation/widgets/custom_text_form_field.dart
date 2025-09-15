import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Icon prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final int maxLength;
  final TextStyle? labelStyle;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.labelStyle,
    this.keyboardType = TextInputType.text,
    this.maxLength = 50, required InputDecoration decoration,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    OutlineInputBorder _border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 1.3),
        );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      cursorColor: const Color(0xFF0C553B),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle ??
            TextStyle(color: isDark ? Colors.white70 : Colors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? Colors.black : Colors.white,
        counterText: "",
        border: _border(isDark ? Colors.white54 : Colors.grey),
        enabledBorder: _border(isDark ? Colors.white54 : Colors.grey),
        focusedBorder: _border(isDark ? Colors.white : const Color(0xFF0C553B)),
      ),
    );
  }
}
