part of 'log_edit_bloc.dart';

@immutable
sealed class LogEditEvent {}

class EditLogEvent extends LogEditEvent {
  late final BuildContext context;
  late final WellnessLog log;

  EditLogEvent({
    required this.context,
    required this.log,
  });
}
