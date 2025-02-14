import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';

import '../../../../model/course_model.dart';

part 'course_details_state.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  CourseDetailsCubit() : super(CourseDetailsInitial());
  Future<void> refresh() async {
    emit(CourseDetailsInitial());
  }

  final box = Hive.box('main');

  bool checkIsRegister({required bool isRegister, required Course course}) {
    if (isRegister) {
      return true;
    }
    if (box.get('courses') != null) {
      List registeredCourses = box.get('courses');
      if (registeredCourses.isEmpty) {
        return false;
      }
      print(box.get('courses'));
      return registeredCourses.indexWhere(
            (element) => element.id == course.id,
          ) !=
          -1;
    } else {
      return false;
    }
  }

  Future<void> registerCourse({required Course course}) async {
    if (await box.get('courses') == null) {
      List<Course> registeredCourses = [];
      await box.put('courses', registeredCourses);
    }
    List storedData = box.get('courses');

    List<Course> registeredCourses = [];
    storedData.forEach(
      (element) => registeredCourses.add(element),
    );

    registeredCourses.add(course);
    await box.put('courses', registeredCourses);
    emit(CourseDetailsInitial());
  }
}
