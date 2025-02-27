import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:login/model/course_model.dart';
import 'package:login/utils/check_role.dart';
import 'package:meta/meta.dart';

import '../../../core/functions/apis_error_handler.dart';
import '../../../server/dio_settings.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int pageSlideIndex = 0;

  List<Course> allCourses = [];
  TextEditingController searchController = TextEditingController();
  PagingController<int, Course> pagingController =
      PagingController(firstPageKey: 1);
  final int pageSize = 20;

  Future<void> initState(
    BuildContext context,
  ) async {
    pagingController.addPageRequestListener(
      (pageKey) {
        getAllCourses(context: context, pageKey: pageKey);
      },
    );
  }

  Future<void> refresh() async {
    pagingController.refresh();
  }

  Future<void> getAllCourses({
    required BuildContext context,
    required int pageKey,
  }) async {
    try {
      emit(HomeLoadingState());
      final String token = await CashNetwork.getCashData(key: 'token');
      final response = await dio().get(
        checkTeacherRole() ? 'my-courses' : 'courses',
        queryParameters: {'page': pageKey, 'search': searchController.text},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        final List jsonData = checkTeacherRole()
            ? await response.data as List
            : await response.data['data'] as List;
        List<Course> newCourses = await jsonData
            .map(
              (e) => Course.fromJson(e),
            )
            .toList();
        allCourses.addAll(newCourses);
        emit(HomeSuccessState(
            newCourses: newCourses,
            isReachMax: checkTeacherRole()
                ? true
                : response.data['links']['next'] == null));
      }
    } on DioException catch (e) {
      errorHandler(e: e, context: context);
      emit(HomeFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      print('================ catch exception =================');
      emit(HomeFailedState(errorMessage: 'Catch exception'));
    }
  }

  Future<void> deleteCourse({
    required BuildContext context,
    required Course currentCourse,
  }) async {
    try {
      emit(HomeDeleteLoadingState());
      final String token = await CashNetwork.getCashData(key: 'token');
      final response = await dio().delete(
        'courses/${currentCourse.id}',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Navigator.pop(context);
        await refresh();
      }
    } on DioException catch (e) {
      Navigator.pop(context);
      errorHandler(e: e, context: context);
      emit(HomeFailedState(errorMessage: e.response!.data['message']));
    } catch (e) {
      Navigator.pop(context);
      print('================ catch exception =================');
      emit(HomeFailedState(errorMessage: 'Catch exception'));
    }
  }

  Future<void> changePageSlideIndex(int index) async {
    pageSlideIndex = index;
    emit(HomeInitial());
  }
}
