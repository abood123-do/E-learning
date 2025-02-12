import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:meta/meta.dart';

part 'start_state.dart';

class StartCubit extends Cubit<StartState> {
  StartCubit() : super(StartInitial());

  Future<void> initState({required BuildContext context}) async {
    print('hello');
    String? token = CashNetwork.getCashData(key: 'token');
    print('the token is => $token');
    if (token.isNotEmpty) {
      String? userType = CashNetwork.getCashData(key: 'role');
      print('the role is => $userType');
      if (userType == "teacher") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home_teacher", (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/application", (route) => false);
      }
    }
  }

  Future<void> changeScreen(BuildContext context) async {
    String? userType = CashNetwork.getCashData(key: 'role');
    print('the role is => $userType');
    if (userType == "teacher") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/home_teacher", (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/application", (route) => false);
    }
  }
}
