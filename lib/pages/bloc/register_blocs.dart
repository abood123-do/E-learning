import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/pages/bloc/register_events.dart';
import 'package:login/pages/bloc/register_states.dart';

class RegisterBlocs extends Bloc<RegisterEvent, RegisterStates> {
  RegisterBlocs() : super(const RegisterStates()) {
    on<UserNameEvent>(_userNameEvent);
    on<EmailEvent>(_emailEvent);
    on<PasswordEvent>(_passwordEvent);
    on<RepasswordEvent>(_rePasswordEvent);
  }
  void _userNameEvent(UserNameEvent event, Emitter<RegisterStates> emit) {
    print("${event.userName}");
    emit(state.copyWith(userName: event.userName));
  }

  void _emailEvent(EmailEvent event, Emitter<RegisterStates> emit) {
    print("${event.email}");
    emit(state.copyWith(email: event.email));
  }

  void _passwordEvent(PasswordEvent event, Emitter<RegisterStates> emit) {
    print("${event..password}");
    emit(state.copyWith(password: event.password));
  }

  void _rePasswordEvent(RepasswordEvent event, Emitter<RegisterStates> emit) {
    print("${event.rePassword}");
    emit(state.copyWith(rePassword: event.rePassword));
  }
}
