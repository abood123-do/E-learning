import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/pages/welcome/bloc/welcom_states.dart';
import 'package:login/pages/welcome/bloc/welcome_events.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomState> {
  WelcomeBloc() : super(WelcomState()) {
    on<WelcomeEvent>((event, emit) {
      emit(WelcomState(page: state.page));
    });
  }
}
