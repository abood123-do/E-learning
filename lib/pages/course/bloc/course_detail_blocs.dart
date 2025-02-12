//يجب تكرار كل شيء حتى تظهر تفاصيل الدورة بشكل صحيح وداخل أحداث السجل
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/pages/course/bloc/course_detail_events.dart';
import 'package:login/pages/course/bloc/course_detail_states.dart';

class CourseDetailBlocs extends Bloc<CourseDetailEvents, CourseDetailStates> {
  CourseDetailBlocs() : super(const CourseDetailStates()) {
    on<TriggerCourseDetail>(
        _triggerCourseDetail); //هذا الحدث لتشغيل تفاصيل الدورة
  }
  void _triggerCourseDetail(
      TriggerCourseDetail event, Emitter<CourseDetailStates> emit) {
    emit(state.copyWith(courseItem: event.courseItem));
  }
}
