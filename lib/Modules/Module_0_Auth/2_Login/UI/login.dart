import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saibya_daily/InputField/custom_input_field.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/1_Register/UI/register.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/2_Login/bloc/login_bloc.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/3_Verification/UI/verification.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/names_of_fonts.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';
import 'package:saibya_daily/Buttons/primary_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneController = TextEditingController();
  bool canSubmit = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to check form validity
    phoneController.addListener(_checkCanSubmit);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _checkCanSubmit() {
    setState(() {
      canSubmit = phoneController.text.length == 10 &&
          RegExp(r'^[0-9]+$').hasMatch(phoneController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true, // Ensure this is true
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: AppColors.onBackground),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        'Login to your Account',
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
                        'Enter your details to get started',
                        style: TextStyle(
                          fontSize: regularFontSize(context),
                          color: AppColors.onBackground.withOpacity(0.6),
                          fontFamily: InterFont,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Phone Field
                      CustomInputField(
                        labelText: 'Phone Number',
                        controller: phoneController,
                        prefixIcon: Icons.phone_outlined,
                        prefixText: '+91 ',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 40),

                      // Login Button
                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginMobilOtpSentState) {
                            // Navigate to verification screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Verification(
                                  phoneNumber: phoneController.text,
                                  isRegistration: false,
                                ),
                              ),
                            );
                          } else if (state is LoginPhoneErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.errorMessage),
                              ),
                            );
                          } else if (state is LoginPhoneOtpNotSentState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Failed to send OTP. Please try again.'),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is LoginPhoneLoadingState) {
                            return PrimaryButton(
                              text: 'Continue',
                              isLoading: true,
                              onPressed: null,
                            );
                          }

                          return PrimaryButton(
                            text: 'Continue',
                            onPressed: canSubmit
                                ? () {
                                    context
                                        .read<LoginBloc>()
                                        .add(LoginPhoneSendOtpEvent(
                                          context: context,
                                          phoneNumber: phoneController.text,
                                        ));
                                  }
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to Saibya Daily? ',
                    style: TextStyle(
                      color: AppColors.onBackground.withOpacity(0.6),
                      fontFamily: InterFont,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
