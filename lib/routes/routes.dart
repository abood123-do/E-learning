import 'package:flutter/material.dart';
import 'package:login/pages/application/cubit/application_cubit.dart';
import 'package:login/pages/course/course_detail.dart';
import 'package:login/pages/course/cubit/course_details_cubit.dart';
import 'package:login/pages/home/home_page.dart';
import 'package:login/pages/register/cubit/register_cubit.dart';
import 'package:login/pages/sign_in/cubit/sign_in_cubit.dart';
import 'package:login/pages/welcome/cubit/welcome_cubit.dart';
import '../pages/application/application_page.dart';
import '../pages/home_teacher/home_t.dart';
import '../pages/home_teacher/page_detail_course_teacher.dart';
import '../pages/register/register.dart';
import '../pages/sign_in/sign_in.dart';
import '../pages/welcome/welcome.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => MultiBlocProvider(
        providers: [
          // BlocProvider(
          //   create: (context) => StartCubit()..initState(context: context),
          // ),
          BlocProvider(
            create: (context) => WelcomeCubit(),
          )
        ],
        child: const Welcome(),
      ),
  // "/home_page": (context) => const MyHomePage(),
  "/home_screen": (context) => const HomePage(),
  "/sign_in": (context) => BlocProvider(
        create: (context) => SignInCubit(),
        child: const SignIn(),
      ),
  "/register": (context) => BlocProvider(
        create: (context) => RegisterCubit(),
        child: const Register(),
      ),
  "/home_teacher": (context) => const HomeTeacher(),
  "/course_detail_teacher": (context) => const CourseDetailteacher(),
  "/course_details": (context) => BlocProvider(
        create: (context) => CourseDetailsCubit(),
        child: const CourseDetail(),
      ),
  "/setting": (context) => const SettingsPage(),
  "/application": (context) => BlocProvider(
        create: (context) => ApplicationCubit(),
        child: const ApplicationPage(),
      ),
};
