import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:meta/meta.dart';

import '../../../core/functions/apis_error_handler.dart';
import '../../../server/dio_settings.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  String userType = "student"; // اختيار افتراضي: طالب
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> changeUserType(String userType) async {
    this.userType = userType;
    emit(RegisterInitial());
  }

  Future<void> signUp({required BuildContext context}) async {
    if (userType == "teacher") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/home_teacher", (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/application", (route) => false);
    }
  }

  Future<void> register({
    required BuildContext context,
  }) async {
    try {
      emit(RegisterLoadingState());
      final response = await dio().post(
        'register',
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
          'role': userType,
        },
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200) {
        await CashNetwork.insertToCash(
            key: 'token', value: response.data['token']);
        await CashNetwork.insertToCash(
            key: 'role', value: response.data['role']);
        emit(RegisterSuccessState());
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(RegisterFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(RegisterFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }
}
