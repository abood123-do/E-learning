part of 'create_course_cubit.dart';

@immutable
sealed class CreateCourseState {}

final class CreateCourseInitial extends CreateCourseState {}

final class CreateCourseLoadingState extends CreateCourseState {}

final class CreateCourseSuccessState extends CreateCourseState {}

final class CreateCourseFailedState extends CreateCourseState {
  final String errorMessage;
  CreateCourseFailedState({required this.errorMessage});
}
