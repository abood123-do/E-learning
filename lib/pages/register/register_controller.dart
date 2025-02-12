import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/pages/bloc/register_blocs.dart';

class RegisterController {
  final BuildContext context;
  const RegisterController({required this.context});

  Future<void> handleEmailRegister() async {
    final state = context.read<RegisterBlocs>().state;
    String userName = state.userName;
    String email = state.email;
    String password = state.password;
    String rePassword = state.rePassword;

    if (userName.isEmpty) {
      print("User name can not be empty");
      // toastInfo(msg: "User name can not be empty");
      // return;
    }

    if (email.isEmpty) {
      print("Email name can not be empty");
      // toastInfo(msg: "Email name can not be empty");
      // return;
    }

    if (password.isEmpty) {
      print("Password name can not be empty");
      // toastInfo(msg: "Password name can not be empty");
      // return;
    }

    if (rePassword.isEmpty) {
      print("Your password confirmation is wrong");
      // toastInfo(msg:"Your password confirmation is wrong");
      // return;
    }
//
    try {
      //قم بتسجيل الدخول إذا كان المستخدم موجود
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        //ارسال البريد الالكتروني
        await credential.user?.sendEmailVerification(); // هون عم يتحقق
        await credential.user?.updateDisplayName(userName); //هون عم يعرض
        print(
            "An email has been sent to your registered email. To activate it please check your email box and click on th elink");
        // toastInfo(msg:"An email has been sent to your registered email. To activate it please check your email box");
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("The password provided is too weak");
        // toastInfo(msg:"The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        print("The email is already in use");
        // toastInfo(msg:"The email provided is too weak");
      } else if (e.code == 'weak-password') {
        print("The password provided is too weak");
        // toastInfo(msg:"The password provided is too weak");
      } else if (e.code == 'invalid-email') {
        print("Your email id is invalid");
        // toastInfo(msg:"Your email id is invalid");
      }
    }
  }
}
