import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'answers_state.dart';

class AnswersCubit extends Cubit<AnswersState> {
  AnswersCubit() : super(AnswersInitial());

  List<String> answers = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  Future<void> selectAnswer(String value, int index) async {
    answers[index] = value;
    emit(AnswersInitial());
  }

  bool checkAnswers() {
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].isEmpty) {
        return false;
      }
    }
    return true;
  }

  int submit(List<Map<String, dynamic>> data) {
    int mark = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i]['correctAnswer'] == answers[i]) {
        mark++;
      }
    }
    return mark;
  }
}
