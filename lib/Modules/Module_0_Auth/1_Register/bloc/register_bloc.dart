import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:saibya_daily/Modules/Module_0_Auth/Data/auth_data.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) {});
    on<RegisterPhoneSendOtpEvent>((event, emit) async {
      emit.call(RegisterPhoneLoadingState());

      try {
        bool response = await AuthData().requestRegistrationOtp(
            event.context, event.name, event.phoneNumber);

        if (response) {
          emit.call(RegisterMobilOtpSentState());
        } else {
          emit.call(RegisterPhoneOtpNotSentState());
        }
      } catch (e) {
        emit.call(RegisterPhoneErrorState(errorMessage: 'API Error'));
      }
    });
  }
}
