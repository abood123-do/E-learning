import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/pages/sign_in/bloc/sign_in_events.dart';
import 'package:login/pages/sign_in/bloc/signin_states.dart';

class SignInBloc extends Bloc<SignInEvent, SigninState> {
  SignInBloc() : super(const SigninState()) {
    on<EmailEvent>(_emailEvent);
    on<PasswordEvent>(_passwordEvent);
  }

  void _emailEvent(EmailEvent event, Emitter<SigninState> php) {
    print("my email is ${event.email}");
    php(state.copywith(email: event.email));
  }

  void _passwordEvent(PasswordEvent event, Emitter<SigninState> emit) {
    print("my password is ${event.password}");
    emit(state.copywith(password: event.password));
  }
}
