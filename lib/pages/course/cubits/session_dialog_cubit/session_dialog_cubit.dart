import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:login/model/session_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/functions/apis_error_handler.dart';
import '../../../../core/shared/local_network.dart';
import '../../../../server/dio_settings.dart';

part 'session_dialog_state.dart';

class SessionDialogCubit extends Cubit<SessionDialogState> {
  SessionDialogCubit() : super(SessionDialogInitial());

  Future<void> deleteSession(
      {required BuildContext context,
      required List<Session> allSession,
      required Session currentSession}) async {
    try {
      emit(SessionDialogLoadingState());
      final String token = CashNetwork.getCashData(key: 'token');
      final response = await dio().delete(
        '/course-sessions/${currentSession.id}',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        Navigator.pop(context);
        allSession.removeWhere(
          (element) => element.id == currentSession.id,
        );
        emit(SessionDialogSuccessState());
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(SessionDialogFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(SessionDialogFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }
}
