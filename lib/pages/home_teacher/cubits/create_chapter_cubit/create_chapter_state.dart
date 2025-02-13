part of 'create_chapter_cubit.dart';

@immutable
sealed class CreateChapterState {}

final class CreateChapterInitial extends CreateChapterState {}

final class CreateChapterPickVideoState extends CreateChapterState {}

final class CreateChapterLoadingState extends CreateChapterState {}

final class CreateChapterSuccessState extends CreateChapterState {}

final class CreateChapterFailedState extends CreateChapterState {
  final String errorMessage;
  CreateChapterFailedState({required this.errorMessage});
}
