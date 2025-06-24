part of 'logs_add_bloc.dart';

@immutable
sealed class LogsAddEvent {}

class AddLogEvent extends LogsAddEvent {
  late final BuildContext context;
  late final WellnessLog log;

  AddLogEvent({
    required this.context,
    required this.log,
  });
}
