import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:login/pages/profile/cubits/profile_cubit/profile_cubit.dart';
import 'package:meta/meta.dart';

import '../../../../core/functions/apis_error_handler.dart';
import '../../../../model/user_model.dart';
import '../../../../server/dio_settings.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.profileCubit}) : super(SettingsInitial());
  final ProfileCubit profileCubit;
  TextEditingController usernameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final box = Hive.box('main');
  final formKey = GlobalKey<FormState>();

  Future<void> initState() async {
    User userData = box.get('user');
    usernameController = TextEditingController(text: userData.name);
    userEmailController = TextEditingController(text: userData.email);
  }

  Future<void> updateData({
    required BuildContext context,
  }) async {
    try {
      emit(SettingsLoadingState());
      final token = CashNetwork.getCashData(key: 'token');
      final response = await dio().post(
        '/users/${CashNetwork.getCashData(key: 'user_id')}',
        data: {
          'name': usernameController.text,
          'email': userEmailController.text,
          'password': passwordController.text,
          '_method': 'PUT'
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        final updatedUser = User.fromJson(response.data);
        box.put('user', updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User data updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        profileCubit.refresh();
      }
    } on DioException catch (e) {
      Navigator.pop(context);
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(SettingsFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      Navigator.pop(context);
      print('================ catch exception =================');
      print(e);
      emit(SettingsFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }
}
