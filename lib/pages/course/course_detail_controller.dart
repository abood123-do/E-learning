import 'package:flutter/cupertino.dart';
import 'package:login/common/entities/course.dart';

class CourseDetailController {
  final BuildContext context;

  CourseDetailController({required this.context});
  void init() async {
    //قادرين على الحصول على المعرف الذي يتم تمريره كلما نقرنا
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    print(args["id"]);
  }

  asyncLoadAllData(int? id) async {
    CourseRequestEntity courseRequestEntity = CourseRequestEntity();
    courseRequestEntity.id = id;
  }
}
