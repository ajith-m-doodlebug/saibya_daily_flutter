part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

class RegisterPhoneLoadingState extends RegisterState {}

class RegisterMobilOtpSentState extends RegisterState {}

class RegisterPhoneOtpNotSentState extends RegisterState {}

class RegisterPhoneErrorState extends RegisterState {
  late final String errorMessage;
  RegisterPhoneErrorState({required this.errorMessage});
}
