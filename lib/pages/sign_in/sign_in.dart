// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:login/pages/sign_in/bloc/sign_in_blocs.dart';
// import 'package:login/pages/sign_in/bloc/sign_in_events.dart';
// import 'package:login/pages/sign_in/bloc/signin_states.dart';
// import 'package:login/pages/sign_in/sign_in_controller.dart';
// import 'package:login/pages/sign_in/widgets/sign_in_widget.dart';

// class SignIn extends StatefulWidget {
//   const SignIn({super.key});

//   @override
//   State<SignIn> createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SignInBloc, SigninState>(
//       builder: (context, state) {
//         return Container(
//           color: Colors.white,
//           child: SafeArea(
//               child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: buildAppBar("Log In"),
//             body: SingleChildScrollView(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildThirdPartyLogin(
//                     context), //استدعاء لدالة الأيقونات الثلاثة الموجودين بأعلى الصفحة
//                 Center(
//                     child: reusableText("or use your email account to login")),
//                 Container(
//                   margin: EdgeInsets.only(top: 36.h),
//                   padding: EdgeInsets.only(left: 25.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       reusableText("Email"),
//                       SizedBox(
//                         height: 5.h,
//                       ),
//                       buildTextField(
//                           "Enter your email address", "email", "user", (value) {
//                         context.read<SignInBloc>().add(EmailEvent(value));
//                       }),
//                       reusableText("Password"),
//                       SizedBox(
//                         height: 5.h,
//                       ),
//                       buildTextField("Enter your password", "password", "lock",
//                           (value) {
//                         context.read<SignInBloc>().add(PasswordEvent(value));
//                       })
//                     ],
//                   ),
//                 ),
//                 forgotPassowrd(),
//                 buildLogInAdnRegButton("Log in", "login", () {
//                   Navigator.of(context).pushNamed("pageST");
//                   //SignInController(constext: context).handleSignIn("Email");
//                 }),
//                 buildLogInAdnRegButton("Sign Up", "register", () {
//                   Navigator.of(context).pushNamed("/register");
//                 }),
//               ],
//             )),
//           )),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/pages/sign_in/bloc/sign_in_blocs.dart';
import 'package:login/pages/sign_in/bloc/sign_in_events.dart';
import 'package:login/pages/sign_in/bloc/signin_states.dart';
import 'package:login/pages/sign_in/widgets/sign_in_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SigninState>(
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
                buildThirdPartyLogin(
                    context), //استدعاء لدالة الأيقونات الثلاثة الموجودين بأعلى الصفحة
                Center(
                    child: reusableText("or use your email account to login")),
                Container(
                  margin: EdgeInsets.only(top: 36.h),
                  padding: EdgeInsets.only(left: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reusableText("Email"),
                      SizedBox(
                        height: 5.h,
                      ),
                      buildTextField(
                          "Enter your email address", "email", "user", (value) {
                        context.read<SignInBloc>().add(EmailEvent(value));
                      }),
                      reusableText("Password"),
                      SizedBox(
                        height: 5.h,
                      ),
                      buildTextField("Enter your password", "password", "lock",
                          (value) {
                        context.read<SignInBloc>().add(PasswordEvent(value));
                      })
                    ],
                  ),
                ),
                forgotPassowrd(),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : buildLogInAdnRegButton("Log in", "login", () async {
                        setState(() {
                          isLoading = true;
                        });

                        // التحقق من البريد الإلكتروني وكلمة المرور
                        String email = context.read<SignInBloc>().state.email;
                        String password =
                            context.read<SignInBloc>().state.password;

                        await Future.delayed(
                            Duration(seconds: 2)); // محاكاة التحميل

                        if (email == "teacher@example.com" &&
                            password == "teacher123") {
                          // إذا كانت البيانات للمُعلم
                          Navigator.of(context).pushNamed("homeTeacher");
                        } else if (email == "student@example.com" &&
                            password == "student123") {
                          // إذا كانت البيانات للطالب
                          Navigator.of(context).pushNamed("/application");
                        } else {
                          // في حالة كانت البيانات خاطئة، يمكن عرض رسالة خطأ هنا
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Invalid email or password")),
                          );
                        }

                        setState(() {
                          isLoading = false;
                        });
                      }),
                buildLogInAdnRegButton("Sign Up", "register", () {
                  Navigator.of(context).pushNamed("/register");
                }),
              ],
            )),
          )),
        );
      },
    );
  }
}
