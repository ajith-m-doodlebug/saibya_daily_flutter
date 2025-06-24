part of 'log_edit_bloc.dart';

@immutable
sealed class LogEditState {}

final class LogEditInitial extends LogEditState {}

class EditLogLoadingState extends LogEditState {}

class EditLogSuccessState extends LogEditState {}

class EditLogErrorState extends LogEditState {
  late final String errorMessage;
  EditLogErrorState({required this.errorMessage});
}
