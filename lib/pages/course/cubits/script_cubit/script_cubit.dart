import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/pages/home_teacher/cubits/answers_cubit/answers_cubit.dart';
import 'package:meta/meta.dart';

import '../../../home_teacher/page_detail_course_teacher.dart';

part 'script_state.dart';

class ScriptCubit extends Cubit<ScriptState> {
  ScriptCubit() : super(ScriptInitial());
  TextEditingController scriptController = TextEditingController();

  Future<void> generateQuiz(BuildContext context) async {
    if (scriptController.text.isEmpty) {
      errorDialog(context: context, text: 'you have to enter a script');
      return;
    }
    emit(ScriptLoadingState());
    await Future.delayed(const Duration(seconds: 15));
    emit(ScriptInitial());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AnswersCubit(),
          child: QuizPreviewPage(),
        ),
      ),
    );
  }
}
