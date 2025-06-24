part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginPhoneSendOtpEvent extends LoginEvent {
  late final BuildContext context;
  late final String phoneNumber;

  LoginPhoneSendOtpEvent({
    required this.context,
    required this.phoneNumber,
  });
}
