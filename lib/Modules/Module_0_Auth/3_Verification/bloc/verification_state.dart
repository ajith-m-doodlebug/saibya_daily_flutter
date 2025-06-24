part of 'verification_bloc.dart';

@immutable
sealed class VerificationState {}

final class VerificationInitial extends VerificationState {}

class VerificationLoadingState extends VerificationState {}

class VerificationSuccessState extends VerificationState {}

class VerificationFailureState extends VerificationState {}

class VerificationErrorState extends VerificationState {
  late final String errorMessage;
  VerificationErrorState({required this.errorMessage});
}

class VerificationPhoneLoadingState extends VerificationState {}

class VerificationMobilOtpSentState extends VerificationState {}

class VerificationPhoneOtpNotSentState extends VerificationState {}

class VerificationPhoneErrorState extends VerificationState {
  late final String errorMessage;
  VerificationPhoneErrorState({required this.errorMessage});
}
