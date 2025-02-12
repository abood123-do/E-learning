import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/common/entities/entities.dart';
import 'package:login/global.dart';
import 'package:login/pages/home/bloc/home_page_blocs.dart';

/*class HomeController {
  final BuildContext context;
  UserItem userProfile = Global.storageService.getUserProfile();
  HomeController({required this.context});

  Future<void> init() async {
    //make sure that user is logged in and then make an api call
    if (Global.storageService.getUserToken().isNotEmpty) {
      var result = await CourseAPI.courseList();
      
      if (result.code == 200) {
        context.read<HomePageBlocs>().add(HomePageCourseItem(result.data!));
      } else {
        print(result.code);
      }
    } else {
      print("User has alrady logged out");
    }
  }
}*/
