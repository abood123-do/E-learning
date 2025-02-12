//حدث لتفاصيل الدورة التدريبية
import 'package:login/common/entities/course.dart';

abstract class CourseDetailEvents {
  const CourseDetailEvents();
}

//هذه فئة لتشغيل تفاصيل الدورة
class TriggerCourseDetail extends CourseDetailEvents {
  const TriggerCourseDetail(this.courseItem)
      : super(); //كل شي تفاصيل بتجيني من الباك بدي أعرضا هون
  final CourseItem courseItem; //عنصر دورة تدريبية
}
