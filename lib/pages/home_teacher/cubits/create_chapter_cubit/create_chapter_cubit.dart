import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/model/course_model.dart';
import 'package:login/model/session_model.dart';
import 'package:login/pages/course/cubits/course_details_cubit/course_details_cubit.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/animation/dialogs/dialogs.dart';
import '../../../../core/functions/apis_error_handler.dart';
import '../../../../core/shared/local_network.dart';
import '../../../../server/dio_settings.dart';

part 'create_chapter_state.dart';

class CreateChapterCubit extends Cubit<CreateChapterState> {
  CreateChapterCubit(
      {required this.currentCourse, required this.courseDetailsCubit})
      : super(CreateChapterInitial());
  Course currentCourse;
  CourseDetailsCubit courseDetailsCubit;
  XFile? sessionVideo;
  final TextEditingController chapterController = TextEditingController();

  VideoPlayerController? _videoPlayerController;
  ChewieController? chewieController;
  final formKey = GlobalKey<FormState>();

  Future<void> pickVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) {
      errorDialog(context: context, text: 'You have to select a video');
      return;
    }
    emit(CreateChapterPickVideoState());
    sessionVideo = pickedFile;
    _videoPlayerController =
        VideoPlayerController.file(File(sessionVideo!.path));
    try {
      // Wait for the video to initialize
      await _videoPlayerController!.initialize();

      // Initialize the Chewie controller
      chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
        ),
      );

      emit(CreateChapterInitial());
    } catch (e) {
      // Handle initialization errors
      print('Error initializing video: $e');
      emit(CreateChapterInitial());
    }
  }

  Future<void> createSession({
    required BuildContext context,
  }) async {
    try {
      if (sessionVideo == null) {
        errorDialog(
            context: context, text: 'you have to pick video for the session');
        return;
      }
      emit(CreateChapterLoadingState());
      final String token = await CashNetwork.getCashData(key: 'token');
      String courseVideoName = sessionVideo!.path.split('/').last;
      FormData formData = FormData.fromMap({
        'session_title': chapterController.text,
        'course_id': currentCourse.id,
        "video": MultipartFile.fromFileSync(
          sessionVideo!.path,
          filename: courseVideoName,
        ),
      });
      final response = await dio().post(
        'course-sessions',
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print('The status code is => ${response.statusCode}\n ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        final newSession = Session.fromJson(response.data);
        currentCourse.sessions.add(newSession);
        courseDetailsCubit.refresh();
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      print('The failed status code is ${e.response!.statusCode}');
      emit(CreateChapterFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      print(e);
      emit(CreateChapterFailedState(errorMessage: 'Catch exception'));
      print(e);
    }
  }
}
