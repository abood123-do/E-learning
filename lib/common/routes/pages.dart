import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/common/routes/names.dart';
import 'package:login/global.dart';
import 'package:login/pages/application/application_page.dart';
import 'package:login/pages/application/bloc/app_blocs.dart';
import 'package:login/pages/bloc/register_blocs.dart';
import 'package:login/pages/course/bloc/course_detail_blocs.dart';
import 'package:login/pages/course/course_detail.dart';
import 'package:login/pages/home/bloc/home_page_blocs.dart';
import 'package:login/pages/home/home_page.dart';
import 'package:login/pages/profile/settings/bloc/settings_blocs.dart';
import 'package:login/pages/profile/settings/settings_page.dart';
import 'package:login/pages/register/register.dart';
import 'package:login/pages/sign_in/bloc/sign_in_blocs.dart';
import 'package:login/pages/sign_in/sign_in.dart';
import 'package:login/pages/welcome/bloc/welcome_blocs.dart';
import 'package:login/pages/welcome/welcome.dart';

class AppPages {
  static List<PageEntity> routes() {
    return [
      PageEntity(
          route: AppRoutes.INITIAL,
          page: const Welcome(),
          bloc: BlocProvider(
            create: (_) => WelcomeBloc(),
          )),
      PageEntity(
          route: AppRoutes.SING_IN,
          page: const SignIn(),
          bloc: BlocProvider(
            create: (_) => SignInBloc(),
          )),
      PageEntity(
          route: AppRoutes.REGISTER,
          page: const Register(),
          bloc: BlocProvider(
            create: (_) => RegisterBlocs(),
          )),
      PageEntity(
          route: AppRoutes.APPLICATION,
          page: const ApplicationPage(),
          bloc: BlocProvider(
            create: (_) => AppBlocs(),
          )),
      PageEntity(
          route: AppRoutes.HOME_PAGE,
          page: const HomePage(),
          bloc: BlocProvider(
            create: (_) => HomePageBlocs(),
          )),
      PageEntity(
          route: AppRoutes.SETTINGS,
          page: const SettingsPage(),
          bloc: BlocProvider(
            create: (_) => SettingsBlocs(),
          )),
      PageEntity(
          route: AppRoutes.COURSE_DETAIL,
          page: const CourseDetail(),
          bloc: BlocProvider(
            create: (_) => CourseDetailBlocs(),
          )),
    ];
  }

  static List<dynamic> allBlocProviders(BuildContext context) {
    List<dynamic> blocProviders = <dynamic>[];
    for (var bloc in routes()) {
      blocProviders.add(bloc.bloc);
    }
    return blocProviders;
  }

  //a modal that covers entire screen as we click on navigator object
  static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {
    if (settings.name != null) {
      //check for route name macthing when navigator gets triggered
      var result = routes().where((Element) => Element.route == settings.name);
      if (result.isNotEmpty) {
        print("first log");
        print(result.first.route);
        bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();
        /* if (result.first.route == AppRoutes.INITIAL && deviceFirstOpen) {
          bool isLoggedin = Global.storageService.getIsLoggedIn();
          if (isLoggedin) {
            return MaterialPageRoute(
                builder: (_) => const ApplicationPage(), settings: settings);
          }
          // print("second log");
          return MaterialPageRoute(
              builder: (_) => const SignIn(), settings: settings);
        }*/
        return MaterialPageRoute(
            builder: (_) => result.first.page, settings: settings);
      }
    }
    print("invalid route name ${settings.name}");
    return MaterialPageRoute(
        builder: (_) => const SignIn(), settings: settings);
  }
}

//unify BlocProvider and routes and pages
class PageEntity {
  String route;
  Widget page;
  dynamic bloc;

  PageEntity({required this.route, required this.page, required this.bloc});
}
