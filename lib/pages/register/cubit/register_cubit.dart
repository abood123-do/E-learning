import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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
}
