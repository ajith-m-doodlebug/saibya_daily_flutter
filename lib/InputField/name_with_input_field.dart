import 'package:flutter/material.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/names_of_fonts.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';

class NameWithInputField extends StatelessWidget {
  const NameWithInputField({
    super.key,
    required this.controller,
    required this.name,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  final String name;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Text(
          name,
          style: TextStyle(
            fontFamily: InterFont,
            fontSize: regularFontSize(context) + 2,
            fontWeight: FontWeight.w500,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 10),

        // Input Field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.secondary,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            fontFamily: InterFont,
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}
