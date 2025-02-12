import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationInitial());

  int index = 0;

  Future<void> changeIndex(int index) async {
    this.index = index;
    emit(ApplicationInitial());
  }
}
