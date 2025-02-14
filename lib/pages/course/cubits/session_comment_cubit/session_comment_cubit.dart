import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:meta/meta.dart';

import '../../../../core/functions/apis_error_handler.dart';
import '../../../../core/shared/local_network.dart';
import '../../../../model/comment_model.dart';
import '../../../../server/dio_settings.dart';

part 'session_comment_state.dart';

class SessionCommentCubit extends Cubit<SessionCommentState> {
  SessionCommentCubit() : super(SessionCommentInitial());
  List<Comment> allComments = [];

  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  Future<void> getAllComment({
    required BuildContext context,
  }) async {
    try {
      emit(SessionCommentLoadingState());
      allComments.clear();
      final String token = await CashNetwork.getCashData(key: 'token');
      final response = await dio().get(
        'notes',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200) {
        final jsonData = response.data['data'] as List;
        allComments = jsonData
            .map(
              (e) => Comment.fromJson(e),
            )
            .toList();
        emit(SessionCommentSuccessState());
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(
          SessionCommentFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(SessionCommentFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }

  Future<void> createComment(
      {required BuildContext context, required int sessionId}) async {
    try {
      if (commentController.text.isEmpty) {
        showToast(context: context, text: 'You have to write a comment first');
        return;
      }
      emit(SessionCommentCrudLoadingState());
      final String token = CashNetwork.getCashData(key: 'token');
      final response = await dio().post(
        'notes',
        data: {
          'user_id': CashNetwork.getCashData(key: 'user_id'),
          'course_session_id': sessionId,
          'note': commentController.text
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        final newComment = Comment.fromJson(response.data);
        allComments.add(newComment);
        emit(SessionCommentCrudSuccessState());
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(SessionCommentCrudFailedState(
          errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(SessionCommentCrudFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }

  Future<void> deleteComment(
      {required BuildContext context, required Comment comment}) async {
    try {
      emit(SessionCommentCrudLoadingState());
      final String token = CashNetwork.getCashData(key: 'token');
      final response = await dio().delete(
        'notes/${comment.id}',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        Navigator.pop(context);
        allComments.removeWhere(
          (element) => element.id == comment.id,
        );
        emit(SessionCommentCrudSuccessState());
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(SessionCommentCrudFailedState(
          errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(SessionCommentCrudFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }
}
