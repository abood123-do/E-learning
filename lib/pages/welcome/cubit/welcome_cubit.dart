import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(WelcomeInitial());
  int pageIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  void changePage(int index) {
    pageIndex = index;
    emit(WelcomeInitial());
  }
}
