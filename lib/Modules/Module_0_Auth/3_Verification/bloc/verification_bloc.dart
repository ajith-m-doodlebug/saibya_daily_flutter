import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/Data/auth_data.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationInitial()) {
    on<VerificationEvent>((event, emit) {});
    on<VerificationResendOtpEvent>((event, emit) async {
      emit.call(VerificationPhoneLoadingState());

      try {
        bool response =
            await AuthData().resendOtp(event.context, event.phoneNumber);

        if (response) {
          emit.call(VerificationMobilOtpSentState());
        } else {
          emit.call(VerificationPhoneOtpNotSentState());
        }
      } catch (e) {
        emit.call(VerificationPhoneErrorState(errorMessage: 'API Error'));
      }
    });

    on<VerificationOtpEvent>((event, emit) async {
      emit.call(VerificationLoadingState());

      try {
        if (event.isRegistration) {
          // Handle registration OTP verification
          bool response = await AuthData().verifyRegistrationOtp(
            event.context,
            event.phoneNumber,
            event.otpCode,
          );

          if (response) {
            emit.call(VerificationSuccessState());
          } else {
            emit.call(VerificationFailureState());
          }
          return;
        } else {
          // Handle registration OTP verification
          bool response = await AuthData().verifyLoginOtp(
            event.context,
            event.phoneNumber,
            event.otpCode,
          );

          if (response) {
            emit.call(VerificationSuccessState());
          } else {
            emit.call(VerificationFailureState());
          }
          return;
        }
      } catch (e) {
        emit.call(VerificationErrorState(errorMessage: 'API Error'));
      }
    });
  }
}
