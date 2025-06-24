import 'package:flutter/material.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: screenWidth(context),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? AppColors.secondary.withOpacity(0.5)
              : AppColors.secondary,
          foregroundColor: isDisabled
              ? AppColors.onSecondary.withOpacity(0.7)
              : AppColors.onSecondary,
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: isDisabled ? 0 : 4,
          shadowColor: AppColors.secondary.withOpacity(0.3),
          disabledBackgroundColor: AppColors.secondary.withOpacity(0.2),
          disabledForegroundColor: AppColors.onSecondary.withOpacity(0.7),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.onSecondary,
                  ),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
