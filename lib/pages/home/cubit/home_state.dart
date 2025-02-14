part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeDeleteLoadingState extends HomeState {}

final class HomeSuccessState extends HomeState {
  final List<Course> newCourses;
  final bool isReachMax;

  HomeSuccessState({required this.newCourses, required this.isReachMax});
}

final class HomeFailedState extends HomeState {
  final String errorMessage;
  HomeFailedState({required this.errorMessage});
}
