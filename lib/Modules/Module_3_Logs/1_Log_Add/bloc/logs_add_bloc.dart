import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:saibya_daily/Models/wellness_log_model.dart';
import 'package:saibya_daily/Modules/Module_3_Logs/Data/logs_data.dart';

part 'logs_add_event.dart';
part 'logs_add_state.dart';

class LogsAddBloc extends Bloc<LogsAddEvent, LogsAddState> {
  LogsAddBloc() : super(LogsAddInitial()) {
    on<LogsAddEvent>((event, emit) {});

    on<AddLogEvent>((event, emit) async {
      emit(AddLogLoadingState());

      try {
        WellnessLog? log =
            await LogsData().createWellnessLog(event.context, event.log);

        if (log != null) {
          emit(AddLogSuccessState());
        } else {
          emit(AddLogErrorState(errorMessage: 'Failed to create log'));
        }
      } catch (e) {
        emit(AddLogErrorState(errorMessage: e.toString()));
      }
    });
  }
}
