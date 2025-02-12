part of 'start_cubit.dart';

@immutable
sealed class StartState {}

final class StartInitial extends StartState {}

final class StartLoginState extends StartState {}
