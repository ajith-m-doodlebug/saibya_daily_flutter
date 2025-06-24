import 'package:flutter/material.dart';
import 'package:saibya_daily/Buttons/primary_button.dart';
import 'package:saibya_daily/Buttons/secondary_button.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/1_Register/UI/register.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/2_Login/UI/login.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/names_of_fonts.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: screenSidePadding,
          child: Column(
            children: [
              // Flexible space at top
              const Spacer(flex: 2),

              // App Logo with glow effect
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/app_icon_secondary.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Welcome text
              Text(
                'Welcome to Saibya Daily 👋',
                style: TextStyle(
                  fontSize: headingFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                  fontFamily: InterFont,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Your daily companion awaits!',
                style: TextStyle(
                  fontSize: regularFontSize(context),
                  color: AppColors.onBackground.withOpacity(0.6),
                  fontFamily: InterFont,
                ),
              ),

              const SizedBox(height: 70),

              // Create Account Button
              PrimaryButton(
                text: 'Create New Account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Register(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // OR divider
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.onBackground.withOpacity(0.2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: AppColors.onBackground.withOpacity(0.5),
                        fontSize: smallFontSize(context),
                        fontFamily: InterFont,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.onBackground.withOpacity(0.2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SecondaryButton(
                text: 'Login to Existing Account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // Terms and Privacy Policy text
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: TextStyle(
                      fontSize: tinyFontSize(context),
                      color: AppColors.onBackground.withOpacity(0.5),
                      height: 1.4,
                      fontFamily: InterFont,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: AppColors.secondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: '\nand '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.secondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
