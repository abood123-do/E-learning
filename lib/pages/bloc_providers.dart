import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/pages/application/bloc/app_blocs.dart';
import 'package:login/pages/bloc/register_blocs.dart';
import 'package:login/pages/sign_in/bloc/sign_in_blocs.dart';
import 'package:login/pages/welcome/bloc/welcome_blocs.dart';

class AppBlocProviders {
  static get allBlocProviders => [
        BlocProvider(lazy: false, create: (context) => WelcomeBloc()),
        BlocProvider(lazy: false, create: (context) => AppBlocs()),
        BlocProvider(create: (context) => SignInBloc()),
        BlocProvider(create: (context) => RegisterBlocs())
      ];
}
