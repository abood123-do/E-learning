import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';

import '../../../core/functions/apis_error_handler.dart';
import '../../../core/shared/local_network.dart';
import '../../../model/user_model.dart';
import '../../../server/dio_settings.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> signIn({required BuildContext context}) async {
    final userType = await CashNetwork.getCashData(key: 'role');
    if (userType == "teacher") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/home_teacher", (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/application", (route) => false);
    }
  }

  final box = Hive.box('main');

  Future<void> signInApi({
    required BuildContext context,
  }) async {
    try {
      emit(SignInLoadingState());
      final response = await dio().post(
        'login',
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200) {
        await CashNetwork.insertToCash(
            key: 'token', value: response.data['token']);
        await CashNetwork.insertToCash(
            key: 'role', value: response.data['role']);
        await CashNetwork.insertToCash(
            key: 'user_name', value: response.data['user']['name']);
        await CashNetwork.insertToCash(
            key: 'user_id', value: response.data['user']['id'].toString());

        final user = User.fromJson(response.data['user']);
        box.put('user', user);
        emit(SignInSuccessState());
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(SignInFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(SignInFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }
}
