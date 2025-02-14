import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:login/model/course_model.dart';
import 'package:meta/meta.dart';

part 'registered_courses_state.dart';

class RegisteredCoursesCubit extends Cubit<RegisteredCoursesState> {
  RegisteredCoursesCubit() : super(RegisteredCoursesInitial());
  List<Course> registeredCourses = [];
  final box = Hive.box('main');

  Future<void> initState() async {
    if (await box.get('courses') != null) {
      List storedData = box.get('courses');
      print(storedData);
      storedData.forEach(
        (element) => registeredCourses.add(element),
      );
      emit(RegisteredCoursesInitial());
    }
  }
}
