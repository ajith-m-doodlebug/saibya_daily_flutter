part of 'verification_bloc.dart';

@immutable
sealed class VerificationEvent {}

class VerificationOtpEvent extends VerificationEvent {
  late final BuildContext context;
  late final bool isRegistration;
  late final String otpCode;
  late final String phoneNumber;
  VerificationOtpEvent({
    required this.context,
    required this.isRegistration,
    required this.otpCode,
    required this.phoneNumber,
  });
}

class VerificationResendOtpEvent extends VerificationEvent {
  late final BuildContext context;
  late final bool isRegistration;
  late final String phoneNumber;
  VerificationResendOtpEvent({
    required this.context,
    required this.isRegistration,
    required this.phoneNumber,
  });
}
