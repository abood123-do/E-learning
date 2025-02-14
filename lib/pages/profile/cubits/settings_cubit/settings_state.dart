part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoadingState extends SettingsState {}

final class SettingsFailedState extends SettingsState {
  final String errorMessage;
  SettingsFailedState({required this.errorMessage});
}

final class SettingsSuccessState extends SettingsState {}
