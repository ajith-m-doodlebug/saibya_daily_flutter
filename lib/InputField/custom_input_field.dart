import 'package:flutter/material.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/names_of_fonts.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final IconData? prefixIcon;
  final String? prefixText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool enabled;
  final Widget? suffixIcon;

  const CustomInputField({
    super.key,
    required this.labelText,
    this.prefixIcon,
    this.prefixText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
      style: TextStyle(
        color: AppColors.onBackground,
        fontFamily: InterFont,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.onBackground.withOpacity(0.6),
        ),
        filled: true,
        fillColor:
            enabled ? AppColors.surface : AppColors.surface.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: AppColors.onBackground.withOpacity(0.6),
              )
            : null,
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: AppColors.onBackground,
          fontFamily: InterFont,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
