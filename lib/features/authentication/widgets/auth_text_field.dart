import 'package:flutter/material.dart';

import 'auth_colors.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.prefix,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.validator,
    this.onChanged,
    this.requiredMark = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool requiredMark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AuthColors.title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (requiredMark)
              const Text(
                ' *',
                style: TextStyle(
                  color: AuthColors.required,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(
            color: AuthColors.title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AuthColors.hint,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: prefix,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 24,
            ),
            suffixIcon: suffix,
            filled: true,
            fillColor: AuthColors.fieldFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: AuthColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: AuthColors.accent,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: Color(0xFFE57373)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: Color(0xFFE57373)),
            ),
          ),
        ),
      ],
    );
  }
}
