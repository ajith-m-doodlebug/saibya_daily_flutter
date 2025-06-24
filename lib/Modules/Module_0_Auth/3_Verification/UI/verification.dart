import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/3_Verification/bloc/verification_bloc.dart';
import 'package:saibya_daily/Modules/Module_1_Base/UI/base.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/names_of_fonts.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';
import 'dart:async';

class Verification extends StatefulWidget {
  final String phoneNumber;
  final String? name; // Only for registration
  final bool isRegistration;

  const Verification({
    super.key,
    required this.phoneNumber,
    this.name,
    required this.isRegistration,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _verifyOtp(BuildContext context) {
    final otpCode = _getOtpCode();
    if (otpCode.length == 6) {
      context.read<VerificationBloc>().add(
            VerificationOtpEvent(
              context: context,
              phoneNumber: widget.phoneNumber,
              otpCode: otpCode,
              isRegistration: widget.isRegistration,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationBloc(),
      child: BlocConsumer<VerificationBloc, VerificationState>(
        listener: (context, state) {
          if (state is VerificationLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is VerificationSuccessState) {
            // Navigate to next screen based on registration/login flow

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Base()),
              (route) => false,
            );
          } else if (state is VerificationFailureState) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid OTP. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
            _clearOtpFields();
          } else if (state is VerificationErrorState) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
            _clearOtpFields();
          } else if (state is VerificationMobilOtpSentState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP sent successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is VerificationPhoneOtpNotSentState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to send OTP. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is VerificationPhoneLoadingState) {
            // Handle resend loading state if needed
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: AppColors.onBackground),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Verify Phone',
                      style: TextStyle(
                        fontSize: headingFontSize(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                        fontFamily: InterFont,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Display name if available (for registration)
                    if (widget.name != null && widget.name!.isNotEmpty) ...[
                      Text(
                        'Hi ${widget.name}!',
                        style: TextStyle(
                          fontSize: regularFontSize(context),
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w600,
                          fontFamily: InterFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Subtitle
                    Text(
                      'We sent a 6-digit code to',
                      style: TextStyle(
                        fontSize: regularFontSize(context),
                        color: AppColors.onBackground.withOpacity(0.6),
                        fontFamily: InterFont,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '+91 ${widget.phoneNumber}',
                      style: TextStyle(
                        fontSize: regularFontSize(context),
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                        fontFamily: InterFont,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 50,
                          height: 60,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            enabled: !_isLoading,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                              fontFamily: InterFont,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.surface.withOpacity(0.08),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      AppColors.onBackground.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      AppColors.onBackground.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.secondary,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      AppColors.onBackground.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }

                              // Auto-verify when all fields are filled
                              if (index == 5 && value.isNotEmpty) {
                                final otpCode = _getOtpCode();
                                if (otpCode.length == 6) {
                                  _verifyOtp(context);
                                }
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 40),

                    // Resend OTP
                    Center(
                      child: _resendTimer > 0
                          ? Text(
                              'Resend OTP in $_resendTimer seconds',
                              style: TextStyle(
                                color: AppColors.onBackground.withOpacity(0.6),
                                fontFamily: InterFont,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                _startResendTimer();
                                context.read<VerificationBloc>().add(
                                      VerificationResendOtpEvent(
                                        context: context,
                                        phoneNumber: widget.phoneNumber,
                                        isRegistration: widget.isRegistration,
                                      ),
                                    );
                              },
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Loading indicator
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
