import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/pages/chat/chat.dart';
import 'package:login/pages/home/home_page.dart';

import '../profile/profile.dart';

Widget buildPage(int index) {
  List<Widget> _widget = [
    const HomePage(),
    Center(
      child: Text("Search"),
    ),
    Center(
      child: Text("Course"),
    ),
    const ChatPage(),
    const ProfilePage(),
  ];
  return _widget[index];
}

var bottomTabs = [
  BottomNavigationBarItem(
      label: "home",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/home.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/home.png",
            color: AppColors.primaryElement,
          ))),
  BottomNavigationBarItem(
      label: "search",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/search2.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/search2.png",
            color: AppColors.primaryElement,
          ))),
  BottomNavigationBarItem(
      label: "course",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/play-circle1.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/play-circle1.png",
            color: AppColors.primaryElement,
          ))),
  BottomNavigationBarItem(
      label: "chat",
      icon: SizedBox(
        width: 20.w,
        height: 20.h,
        child: const Icon(Icons.smart_button),
        //Image.asset("assets/icons/message-circle.png"),
      ),
      activeIcon: SizedBox(
          width: 20.w,
          height: 20.h,
          child: const Icon(
            Icons.smart_button,
            // Image.asset(
            //   "assets/icons/message-circle.png",
            color: AppColors.primaryElement,
          ))),
  BottomNavigationBarItem(
      label: "profile",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/person2.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/person2.png",
            color: AppColors.primaryElement,
          )))
];
