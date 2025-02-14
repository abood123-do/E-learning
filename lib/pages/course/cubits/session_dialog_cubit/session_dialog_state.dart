part of 'session_dialog_cubit.dart';

@immutable
sealed class SessionDialogState {}

final class SessionDialogInitial extends SessionDialogState {}

final class SessionDialogLoadingState extends SessionDialogState {}

final class SessionDialogSuccessState extends SessionDialogState {}

final class SessionDialogFailedState extends SessionDialogState {
  final String errorMessage;
  SessionDialogFailedState({required this.errorMessage});
}
