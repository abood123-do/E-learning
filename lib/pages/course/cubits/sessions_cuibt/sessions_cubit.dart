import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login/model/session_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/functions/apis_error_handler.dart';
import '../../../../server/dio_settings.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit() : super(SessionsInitial());
  List<Session> allSessions = [];

  Future<void> getAllSessions({
    required BuildContext context,
  }) async {
    try {
      emit(SessionsLoadingState());
      allSessions.clear();
      final response = await dio().get(
        'course-sessions',
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200) {
        final jsonData = response.data['data'] as List;
        allSessions = jsonData
            .map(
              (e) => Session.fromJson(e),
            )
            .toList();
        emit(SessionsSuccessState());
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(SessionsFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(SessionsFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }
}
