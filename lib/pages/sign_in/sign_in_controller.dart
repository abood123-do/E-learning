import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/common/entities/entities.dart';
import 'package:login/common/values/constant.dart';
import 'package:login/global.dart';
import 'package:login/pages/sign_in/bloc/sign_in_blocs.dart';

class SignInController {
  final BuildContext constext;
  const SignInController({required this.constext});
  Future<void> handleSignIn(String type) async {
    try {
      if (type == "email") {
        //BlocProvider.of<SignInBloc>(context).state
        final state = constext.read<SignInBloc>().state;
        String emailAddress = state.email;
        String password = state.password;
        if (emailAddress.isEmpty) {
          print("email empty");
          //toastInfo(msg: "you need to fill email address");
          //return;
        }
        if (password.isEmpty) {
          print("password empty");
          //toastInfo(msg: "you need to fill password");
          //return;
        }
        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailAddress, password: password);
          if (credential.user == null) {
            print("you don't exist");
            //toastInfo(msg: "you don't exist");
            //return;
          }
          if (!credential.user!.emailVerified) {
            print("you need to verify your email account");
            //toastInfo(msg: "you need to verify your email account");
            //return;
          }
          var user = credential.user;
          if (user != null) {
            String? displayName = user.displayName;
            String? email = user.email;
            String? id = user.uid;
            String? photoUrl = user.photoURL;

            LoginRequestEntity loginRequestEntity = LoginRequestEntity();
            loginRequestEntity.avatar = photoUrl;
            loginRequestEntity.name = displayName;
            loginRequestEntity.email = email;
            loginRequestEntity.open_id = id;
            //type 1 means email login
            loginRequestEntity.type = 1;

            print("user exist");
            Global.storageService
                .setString(AppConstants.STORAGE_USER_TOKEN_KEY, "12345678");
            Navigator.of(constext)
                .pushNamedAndRemoveUntil("/application", (route) => false);
            //we got verified user from firebase
          } else {
            print("Currently you are not a user of this app");
            //toastInfo(msg: "Currently you are not a user of this app");
            return;
            //we have error getting user from firebase
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
            //toastInfo(msg: "No user found for that email");
          } else if (e.code == 'wrong-password') {
            print('wrong password provided for that user');
            //toastInfo(msg: "Wrong password provided for that user");
          } else if (e.code == 'invalid-email') {
            print("your email format is wrong");
            //toastInfo(msg: "your email address format is wrong");
          }
        }
      }
    } catch (e) {}
  }
}

void asyncPostAllData(LoginRequestEntity loginRequestEntity) {}
