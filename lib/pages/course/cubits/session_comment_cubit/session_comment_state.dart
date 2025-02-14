part of 'session_comment_cubit.dart';

@immutable
sealed class SessionCommentState {}

final class SessionCommentInitial extends SessionCommentState {}

final class SessionCommentLoadingState extends SessionCommentState {}

final class SessionCommentSuccessState extends SessionCommentState {}

final class SessionCommentFailedState extends SessionCommentState {
  final String errorMessage;
  SessionCommentFailedState({required this.errorMessage});
}

final class SessionCommentCrudLoadingState extends SessionCommentState {}

final class SessionCommentCrudSuccessState extends SessionCommentState {}

final class SessionCommentCrudFailedState extends SessionCommentState {
  final String errorMessage;
  SessionCommentCrudFailedState({required this.errorMessage});
}
