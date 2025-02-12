import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/pages/sign_in/cubit/sign_in_cubit.dart';

import 'package:login/pages/sign_in/widgets/sign_in_widget.dart';
import 'package:login/utils/validate_input.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    final signInCubit = context.read<SignInCubit>();
    final Validate validate = Validate(context: context);
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: SafeArea(
              child: Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar("Log In"),
            body: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // buildThirdPartyLogin(
                //     context), //استدعاء لدالة الأيقونات الثلاثة الموجودين بأعلى الصفحة
                // Center(
                //     child: reusableText("or use your email account to login")),
                Container(
                  margin: EdgeInsets.only(top: 36.h),
                  padding: EdgeInsets.only(left: 25.w),
                  child: Form(
                    key: signInCubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reusableText("Email"),
                        SizedBox(
                          height: 5.h,
                        ),
                        buildTextField(
                            "Enter your email address",
                            "email",
                            Icons.email,
                            signInCubit.emailController,
                            validate.validateEmail,
                            false),
                        reusableText("Password"),
                        SizedBox(
                          height: 5.h,
                        ),
                        buildTextField(
                            "Enter your password",
                            "password",
                            Icons.lock,
                            signInCubit.passwordController,
                            validate.validatePassword,
                            true),
                      ],
                    ),
                  ),
                ),
                forgotPassowrd(),
                buildLogInAdnRegButton("Log in", "login", () async {
                  if (signInCubit.formKey.currentState!.validate()) {
                    await signInCubit.signInApi(context: context);
                  }
                }, signInCubit),
                buildLogInAdnRegButton("Sign Up", "register", () {
                  Navigator.of(context).pushNamed("/register");
                }, signInCubit),
              ],
            )),
          )),
        );
      },
    );
  }
}
