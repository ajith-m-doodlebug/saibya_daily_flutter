import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saibya_daily/InputField/custom_input_field.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/1_Register/bloc/register_bloc.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/2_Login/UI/login.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/3_Verification/UI/verification.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/names_of_fonts.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';
import 'package:saibya_daily/Buttons/primary_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool canSubmit = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to check form validity
    nameController.addListener(_checkCanSubmit);
    phoneController.addListener(_checkCanSubmit);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _checkCanSubmit() {
    setState(() {
      canSubmit = nameController.text.isNotEmpty &&
          phoneController.text.length == 10 &&
          RegExp(r'^[0-9]+$').hasMatch(phoneController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
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
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Create Account',
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

                    // Name Field
                    CustomInputField(
                      labelText: 'Full Name',
                      controller: nameController,
                      prefixIcon: Icons.person_2_outlined,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 20),

                    // Phone Field
                    CustomInputField(
                      labelText: 'Phone Number',
                      controller: phoneController,
                      prefixIcon: Icons.phone_outlined,
                      prefixText: '+91 ',
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 40),

                    // Register Button
                    BlocConsumer<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterMobilOtpSentState) {
                          // Navigate to verification screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Verification(
                                phoneNumber: phoneController.text,
                                name: nameController.text,
                                isRegistration: true,
                              ),
                            ),
                          );
                        } else if (state is RegisterPhoneErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Number already registered'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterPhoneLoadingState) {
                          return PrimaryButton(
                            text: 'Continue',
                            isLoading: true,
                            onPressed: null,
                          );
                        }
                        if (state is RegisterPhoneErrorState ||
                            state is RegisterPhoneOtpNotSentState) {
                          return PrimaryButton(
                            text: 'Number already registered',
                            isLoading: false,
                            onPressed: null,
                          );
                        }

                        return PrimaryButton(
                          text: 'Continue',
                          onPressed: canSubmit
                              ? () {
                                  context
                                      .read<RegisterBloc>()
                                      .add(RegisterPhoneSendOtpEvent(
                                        context: context,
                                        name: nameController.text,
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

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
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
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
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
