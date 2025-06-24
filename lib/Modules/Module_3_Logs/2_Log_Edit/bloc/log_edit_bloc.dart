import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:saibya_daily/Models/wellness_log_model.dart';
import 'package:saibya_daily/Modules/Module_3_Logs/Data/logs_data.dart';

part 'log_edit_event.dart';
part 'log_edit_state.dart';

class LogEditBloc extends Bloc<LogEditEvent, LogEditState> {
  LogEditBloc() : super(LogEditInitial()) {
    on<LogEditEvent>((event, emit) {});

    on<EditLogEvent>((event, emit) async {
      emit(EditLogLoadingState());

      try {
        WellnessLog? log = await LogsData().updateWellnessLog(
            event.context, event.log.id,
            sleepHours: event.log.sleepHours,
            moodRating: event.log.moodRating,
            hydrationLiters: event.log.hydrationLiters,
            meals: event.log.meals,
            notes: event.log.notes);

        if (log != null) {
          emit(EditLogSuccessState());
        } else {
          emit(EditLogErrorState(errorMessage: 'Failed to create log'));
        }
      } catch (e) {
        emit(EditLogErrorState(errorMessage: e.toString()));
      }
    });
  }
}
