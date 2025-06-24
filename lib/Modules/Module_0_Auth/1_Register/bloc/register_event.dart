part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterPhoneSendOtpEvent extends RegisterEvent {
  late final BuildContext context;
  late final String name;
  late final String phoneNumber;

  RegisterPhoneSendOtpEvent({
    required this.context,
    required this.name,
    required this.phoneNumber,
  });
}
