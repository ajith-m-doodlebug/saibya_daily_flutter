part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginPhoneLoadingState extends LoginState {}

class LoginMobilOtpSentState extends LoginState {}

class LoginPhoneOtpNotSentState extends LoginState {}

class LoginPhoneErrorState extends LoginState {
  late final String errorMessage;
  LoginPhoneErrorState({required this.errorMessage});
}
