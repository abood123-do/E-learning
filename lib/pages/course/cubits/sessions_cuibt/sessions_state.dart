part of 'sessions_cubit.dart';

@immutable
sealed class SessionsState {}

final class SessionsInitial extends SessionsState {}

final class SessionsLoadingState extends SessionsState {}

final class SessionsSuccessState extends SessionsState {}

final class SessionsFailedState extends SessionsState {
  final String errorMessage;
  SessionsFailedState({required this.errorMessage});
}
