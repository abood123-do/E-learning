import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/common/widgets/base_text_widget.dart';
import 'package:login/model/course_model.dart';
import 'package:login/pages/course/cubits/course_details_cubit/course_details_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../server/image_server.dart';

AppBar buildAppBar() {
  return AppBar(
    title: reusbaleSubTitletext("Course detail"),
  );
}

Widget thumbNail(String? courseImage) {
  return Container(
    width: 325.w,
    height: 200.h,
    decoration: const BoxDecoration(
      image: DecorationImage(
          fit: BoxFit.fitWidth, image: AssetImage("assets/icons/video.png")),
    ),
    child: courseImage == null
        ? const SizedBox()
        : ClipRRect(
            borderRadius: BorderRadius.circular(15.w),
            child: CachedNetworkImage(
              imageUrl: '${ImageUrl.imageUrl}/$courseImage',
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 325.w,
                  height: 200.h,
                  // padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 90),
                  decoration: const BoxDecoration(color: Colors.white),
                  alignment: Alignment.center,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              width: 325.w,
              height: 200.h,
            ),
          ),
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

Widget descriptionText(String description) {
  return reusbaleSubTitletext(description,
      color: AppColors.primaryThreeElementText,
      fontWeight: FontWeight.normal,
      fontSize: 11.sp);
}

Widget registrCourse(String name, BuildContext context, Course course) {
  // متغير لتخزين حالة الزر
  final courseDetailsCubit = context.read<CourseDetailsCubit>();
  return BlocConsumer<CourseDetailsCubit, CourseDetailsState>(
    listener: (context, state) {},
    builder: (context, state) {
      return StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () async {
              if (await courseDetailsCubit.checkIsRegister(
                  isRegister: course.isRegistered, course: course)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You already registered to this course"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              await courseDetailsCubit.registerCourse(course: course);
              // إظهار الإشعار
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("You have successfully registered for $name!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(top: 13.h),
              width: 330.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: courseDetailsCubit.checkIsRegister(
                        course: course, isRegister: course.isRegistered)
                    ? Colors.green
                    : AppColors.primaryElement,
                borderRadius: BorderRadius.circular(10.w),
                border: Border.all(
                  color: courseDetailsCubit.checkIsRegister(
                          course: course, isRegister: course.isRegistered)
                      ? Colors.green
                      : AppColors.primaryElement,
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: courseDetailsCubit.checkIsRegister(
                          course: course, isRegister: course.isRegistered)
                      ? Colors.white
                      : AppColors.primaryElementText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget courseSummaryTitle() {
  return reusbaleSubTitletext("The Course Includes", fontSize: 14.sp);
}

//setting sections buttons

Widget courseSummaryView(BuildContext context, Course course) {
  var imagesInfo = <String, String>{
    "${course.hours} Hours": "video_detail.png",
    "Total ${course.sessions.length} lessons": "file_detail.png",
    // "67 Downloadable": "download_detail.png",
  };
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
      ],
    ),
    child: Row(
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
                // _listContainer(
                //     fontSize: 9,
                //     color: AppColors.primaryThreeElementText,
                //     fontWeight: FontWeight.normal)
              ],
            ),
          ],
        ),
        Container(
          child: Image(
            height: 25.h,
            width: 15.h,
            image: AssetImage("assets/icons/arrow_right.png"),
          ),
        )
      ],
    ),
  );
}

Widget _listContainer(
    {double fontSize = 13,
    Color color = AppColors.primaryText,
    fontWeight = FontWeight.bold}) {
  return Container(
    width: 200.w,
    margin: EdgeInsets.only(left: 10.w),
    child: Text(
      "Lesson List",
      //overflow: TextOverflow.clip,
      //maxLines: 1,
      style: TextStyle(
          color: color, fontSize: fontSize.sp, fontWeight: FontWeight.bold),
    ),
  );
}
