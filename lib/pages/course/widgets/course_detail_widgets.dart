import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/common/widgets/base_text_widget.dart';

import '../../common_widgets.dart';

AppBar buildAppBar() {
  return AppBar(
    title: reusbaleSubTitletext("Course detail"),
  );
}
//رح يكون في عنا الذهاب للشراء وبعد ذلك يمكنك  أن تعرض الدورة التدريبية الخاصة بك حيث تتمضن هذه الدورة الكثير من المعلومات

Widget thumbNail() {
  return Container(
    width: 325.w,
    height: 200.h,
    decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fitWidth, image: AssetImage("assets/icons/video.png"))),
  );
}

Widget menuView() {
  //عرض القائمة
  return SizedBox(
    width: 325.w,
    child: Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 211, 163, 19),
                borderRadius: BorderRadius.circular(7.w),
                border:
                    Border.all(color: const Color.fromARGB(255, 211, 163, 19))),
            child: reusbaleSubTitletext("Author Page",
                color: AppColors.primaryElementText,
                fontWeight: FontWeight.normal,
                fontSize: 10.sp),
          ),
        ),
        _iconAndNum("assets/icons/people.png", 0),
        _iconAndNum("assets/icons/star.png", 0)
      ],
    ),
  );
}

Widget _iconAndNum(String iconPath, int num) {
  return Container(
    margin: EdgeInsets.only(left: 30.w),
    child: Row(
      children: [
        Image(
          image: AssetImage(iconPath),
          width: 20.w,
          height: 20.h,
        ),
        reusbaleSubTitletext(num.toString(),
            color: AppColors.primaryThreeElementText,
            fontSize: 11.sp,
            fontWeight: FontWeight.normal)
      ],
    ),
  );
}

Widget descriptionText() {
  return reusbaleSubTitletext(
      "Learn how to build an ios and android app using flutter. This tutorial is free for students on youtube. You will watch half of it and youtube. And the complete course is on Udemy.This is a latest mobile app development app using BLoC pattern or BLoC state management, This app covers topics for beginners to advanced learners",
      color: AppColors.primaryThreeElementText,
      fontWeight: FontWeight.normal,
      fontSize: 11.sp);
}

Widget goBuyButton(String name) {
  //هاد الزر مشان ياخدني على صفحة شراء الكورس
  return Container(
    padding: EdgeInsets.only(top: 13.h),
    width: 330.w,
    height: 50.h,
    decoration: BoxDecoration(
        color: AppColors.primaryElement,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: const Color.fromARGB(255, 211, 163, 19))),
    child: Text(
      name,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: AppColors.primaryElementText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal),
    ),
  );
}

Widget courseSummaryTitle() {
  return reusbaleSubTitletext("The Course Includes", fontSize: 14.sp);
}

//setting sections buttons
var imagesInfo = <String, String>{
  "36 Hours": "video_detail.png",
  "Total 30 lessons": "file_detail.png",
  "67 Downloadable": "download_detail.png",
};
Widget courseSummaryView(BuildContext context) {
  return Column(
    children: [
      ...List.generate(
          imagesInfo.length,
          (index) => GestureDetector(
                onTap: () => null,
                child: Container(
                  margin: EdgeInsets.only(top: 15.h),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                            "assets/icons/${imagesInfo.values.elementAt(index)}"),
                        //padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                            color: const Color.fromARGB(255, 14, 42, 203)),
                        width: 30.w,
                        height: 30.h,
                      ),
                      SizedBox(width: 15.w),
                      Text(
                        imagesInfo.keys.elementAt(index),
                        style: TextStyle(
                            color: AppColors.primarySecondaryElementText,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
              ))
    ],
  );
}

Widget courseLessonList() {
  return Container(
      //هاد المربع يلي تحت lesson List
      width: 325.w,
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 1)),
          ]),
      child: InkWell(
        onTap: () {},
        child:
            //for image and the text
            Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.h),
                      image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/icons/Image(1).png"))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // List item title
                    _listContainer(),
                    //list item description//الوصف
                    _listContainer(
                        fontSize: 9,
                        color: AppColors.primaryThreeElementText,
                        fontWeight: FontWeight.normal)
                  ],
                )
              ],
            ),
            //for showing the right arrow
            Container(
              child: Image(
                height: 25.h,
                width: 15.h,
                image: AssetImage("assets/icons/arrow_right.png"),
              ),
            )
          ],
        ),
      ));
}

Widget _listContainer(
    {double fontSize = 13,
    Color color = AppColors.primaryText,
    fontWeight = FontWeight.bold}) {
  return Container(
    width: 200.w,
    margin: EdgeInsets.only(left: 10.w),
    child: Text(
      "UI Design",
      overflow: TextOverflow.clip,
      maxLines: 1,
      style: TextStyle(
          color: color, fontSize: fontSize.sp, fontWeight: FontWeight.bold),
    ),
  );
}
