import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> signIn({required BuildContext context}) async {
    if (emailController.text == "teacher@example.com" &&
        passwordController.text == "teacher123") {
      // إذا كانت البيانات للمُعلم
      Navigator.of(context).pushNamed("homeTeacher");
    } else if (emailController.text == "student@example.com" &&
        passwordController.text == "student123") {
      // إذا كانت البيانات للطالب
      Navigator.of(context).pushNamed("/application");
    } else {
      // في حالة كانت البيانات خاطئة، يمكن عرض رسالة خطأ هنا
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }
}
