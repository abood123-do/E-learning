part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

final class SignInLoadingState extends SignInState {}

final class SignInSuccessState extends SignInState {}

final class SignInFailedState extends SignInState {
  final String errorMessage;
  SignInFailedState({required this.errorMessage});
}
