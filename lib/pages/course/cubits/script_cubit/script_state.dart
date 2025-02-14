part of 'script_cubit.dart';

@immutable
sealed class ScriptState {}

final class ScriptInitial extends ScriptState {}

final class ScriptLoadingState extends ScriptState {}
