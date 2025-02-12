import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/pages/home/cubit/home_cubit.dart';

import '../../../common/widgets/base_text_widget.dart';
import '../../../model/course_model.dart';

AppBar buildAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Container(
      margin: EdgeInsets.only(left: 7.h, right: 7.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 12.h,
            //child: Image.asset("assets/icons/menu.png"),
          ),
          GestureDetector(
            //مشان يكون قابل للنقر
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/menu.png"))),
            ),
          )
        ],
      ),
    ),
  );
}

//reusable big text widget
Widget HomePageText(String text,
    {Color color = AppColors.primaryText, int top = 20}) {
  return Container(
    margin: EdgeInsets.only(top: top.h),
    child: Text(
      text,
      style:
          TextStyle(color: color, fontSize: 24.sp, fontWeight: FontWeight.bold),
    ),
  );
}

Widget searchView() {
  return Row(
    children: [
      Container(
          width: 280.w,
          height: 40.h,
          decoration: BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.circular(15.h),
              border: Border.all(color: AppColors.primaryFourElementText)),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 17.w),
                width: 16.w,
                height: 16.w,
                child: Image.asset("assets/icons/search.png"),
              ),
              Container(
                width: 140.w,
                height: 40.h,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      hintText: "search your couse",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      hintStyle: TextStyle(
                          //نمط النص
                          color: AppColors.primarySecondaryElementText)),
                  style: TextStyle(
                      color: AppColors.primaryText,
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.normal,
                      fontSize: 14.sp),
                  autocorrect: false,
                  obscureText: false,
                ),
              ),
            ],
          ))
    ],
  );
}

//for sliders view
Widget slidersView(BuildContext context, HomeCubit homeCubit) {
  return BlocConsumer<HomeCubit, HomeState>(
    listener: (context, state) {},
    builder: (context, state) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.h),
            width: 325.w,
            height: 160.h,
            child: PageView(
              onPageChanged: (value) {
                homeCubit.changePageSlideIndex(value);
              },
              children: [
                slidersContainer(path: "assets/icons/image(4).png"),
                slidersContainer(path: "assets/icons/image(3).png"),
                slidersContainer(path: "assets/icons/Art.png")
              ],
            ),
          ),
          SizedBox(
            child: DotsIndicator(
              //هي مشان النقاط يلي تحت الصورة لما غير صورة يتغير معها
              dotsCount: 3,
              position: homeCubit.pageSlideIndex,
              decorator: DotsDecorator(
                  color: AppColors.primaryThreeElementText,
                  activeColor: AppColors.primaryElement,
                  size: const Size.square(5.0),
                  activeSize: const Size(17.0, 5.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
          )
        ],
      );
    },
  );
}

//sliders widget
Widget slidersContainer({String path = "assets/icons/Art.png"}) {
  return Container(
    width: 325.w,
    height: 160.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.h)),
        image: DecorationImage(fit: BoxFit.fill, image: AssetImage(path))),
  );
}

//menu view for shoing items
Widget menuView() {
  return Column(
    children: [
      Container(
        width: 325.w,
        margin: EdgeInsets.only(top: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            reusbaleSubTitletext("Choose your courses"),
          ],
        ),
      ),
    ],
  );
}

//for the menu buttons,reusbale text
Widget reusableMenuText(String menuText,
    {Color textColor = AppColors.primaryElementText,
    Color backGroundColor = AppColors.primaryElement}) {
  return Container(
    margin: EdgeInsets.only(right: 20.w),
    decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(7.w),
        border: Border.all(color: backGroundColor)),
    padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 5.h, bottom: 5.h),
    child: reusbaleSubTitletext(menuText,
        color: textColor, fontWeight: FontWeight.normal, fontSize: 11),
  );
}

//for course grid view UI
//شبكة الدورة التدريبية يجب أن تحتوي على حدث عند النقر
Widget courseGrid({required Course course}) {
  return Container(
    padding: EdgeInsets.all(12.w),
    width: 100,
    height: 100,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        image: const DecorationImage(
            fit: BoxFit.fill, image: AssetImage("assets/icons/Image(1).png"))),
    child: Column(
      // هون مشان اكتب داخل الصورة
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          maxLines: 1,
          overflow: TextOverflow
              .fade, //هون صرت قد ما بكتب داخل الصورة ما بيطلع براتا حتى لو كان النص طويل
          textAlign: TextAlign.left,
          softWrap: false,
          style: TextStyle(
              color: AppColors.primaryElementText,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          course.description!,
          maxLines: 1,
          overflow: TextOverflow
              .ellipsis, //هون صرت قد ما بكتب داخل الصورة ما بيطلع براتا حتى لو كان النص طويل
          textAlign: TextAlign.left,
          softWrap: false,
          style: TextStyle(
              color: AppColors.primaryFourElementText,
              fontWeight: FontWeight.normal,
              fontSize: 8.sp),
        )
      ],
    ),
  );
}

Widget courseStatisticsWidget({
  required int studentCount,
  required int courseCount,
}) {
  return Container(
    padding: EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade300, Colors.blue.shade900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 12.0,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(
                "Students", studentCount, Icons.people, Colors.orangeAccent),
            _buildStatCard(
                "Courses", courseCount, Icons.book, Colors.greenAccent),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStatCard(String title, int count, IconData icon, Color color) {
  return Container(
    padding: EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8.0,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 30.0,
          child: Icon(icon, color: Colors.white, size: 30.0),
        ),
        SizedBox(height: 12.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6.0),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
