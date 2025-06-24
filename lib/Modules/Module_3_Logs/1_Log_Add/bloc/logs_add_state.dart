part of 'logs_add_bloc.dart';

@immutable
sealed class LogsAddState {}

final class LogsAddInitial extends LogsAddState {}

class AddLogLoadingState extends LogsAddState {}

class AddLogSuccessState extends LogsAddState {}

class AddLogErrorState extends LogsAddState {
  late final String errorMessage;
  AddLogErrorState({required this.errorMessage});
}
