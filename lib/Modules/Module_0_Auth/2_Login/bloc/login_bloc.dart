import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/Data/auth_data.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});
    on<LoginPhoneSendOtpEvent>((event, emit) async {
      emit.call(LoginPhoneLoadingState());

      try {
        bool response =
            await AuthData().requestLoginOtp(event.context, event.phoneNumber);

        if (response) {
          emit.call(LoginMobilOtpSentState());
        } else {
          emit.call(LoginPhoneOtpNotSentState());
        }
      } catch (e) {
        emit.call(LoginPhoneErrorState(errorMessage: 'API Error'));
      }
    });
  }
}
