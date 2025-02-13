import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/model/course_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/functions/apis_error_handler.dart';
import '../../../../core/shared/local_network.dart';
import '../../../../server/dio_settings.dart';
import '../../../home/cubit/home_cubit.dart';

part 'create_course_state.dart';

class CreateCourseCubit extends Cubit<CreateCourseState> {
  CreateCourseCubit({required this.homeCubit}) : super(CreateCourseInitial());
  HomeCubit homeCubit;

  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseDetailsController = TextEditingController();
  final TextEditingController courseHoursController = TextEditingController();
  final TextEditingController totalLessonsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isImageAdded = false;
  XFile? courseImage;

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      errorDialog(context: context, text: 'You have to select an image');
      return;
    }
    courseImage = pickedFile;
    emit(CreateCourseInitial());
  }

  Future<void> createCourse({
    required BuildContext context,
  }) async {
    try {
      emit(CreateCourseLoadingState());
      final String token = await CashNetwork.getCashData(key: 'token');
      String courseImageName = courseImage!.path.split('/').last;

      FormData formData = FormData.fromMap({
        'title': courseNameController.text,
        'description': courseDetailsController.text,
        'level_id': 1,
        'hours': courseHoursController.text,
        "image": MultipartFile.fromFileSync(
          courseImage!.path,
          filename: courseImageName,
        ),
      });
      final response = await dio().post(
        'courses',
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        final createdCourse = Course.fromJson(response.data);
        homeCubit.refresh();
        Navigator.of(context).pushReplacementNamed('/course_details',
            arguments: {'course': createdCourse});
        emit(CreateCourseSuccessState());
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(CreateCourseFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(CreateCourseFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }
}
