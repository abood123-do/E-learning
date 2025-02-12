import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int pageSlideIndex = 0;

  Future<void> initState() async {}

  Future<void> changePageSlideIndex(int index) async {
    pageSlideIndex = index;
    emit(HomeInitial());
  }
}
