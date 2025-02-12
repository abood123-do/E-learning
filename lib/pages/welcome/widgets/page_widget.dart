import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/values/colors.dart';
import '../../../common/values/constant.dart';
import '../../../global.dart';
import '../cubit/welcome_cubit.dart';

class PageWidget extends StatelessWidget {
  const PageWidget(
      {super.key,
      required this.index,
      required this.buttonName,
      required this.title,
      required this.subTitle,
      required this.imagePath});

  final String buttonName;
  final String title;
  final String subTitle;
  final String imagePath;
  final int index;

  @override
  Widget build(BuildContext context) {
    final welcomeCubit = context.read<WelcomeCubit>();
    return Column(
      children: [
        SizedBox(
          width: 345.w,
          height: 345.w,
          child: Image.asset(
            imagePath,
          ),
        ),
        Container(
          child: Text(
            title,
            style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 24.sp,
                fontWeight: FontWeight.normal),
          ),
        ),
        Container(
          width: 375.w,
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: Text(subTitle,
              style: TextStyle(
                  color: AppColors.primarySecondaryElementText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal)),
        ),
        GestureDetector(
          onTap: () {
            //هي مشان إذا كبست على الزر حددت أديش بدو ياخد وقت لينتقل للصفحة الثانية وشو نوع الانتقال
            //within 0-2 index
            if (index < 3) {
              welcomeCubit.pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate);
            } else {
              Global.storageService
                  .setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME, true);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/sign_in",
                  (route) =>
                      false); //هي بتخلي أنو لما أوصل على الصفحة الثالثة وأعمل ستارت بياخدني على الصفحة اللي بعدها وما عاد في زر رجوع
            }
          },
          child: Container(
            //الزر البني
            margin: EdgeInsets.only(top: 100.h, left: 25.w, right: 25.w),
            width: 325.w,
            height: 50.h,
            decoration: BoxDecoration(
                //خليت الزر البني يصيرو الحواف تبعو دائرية
                color: AppColors.primaryElement,
                borderRadius: BorderRadius.all(Radius.circular(15.w)),
                boxShadow: [
                  //ساوي ظل للزر
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ]),
            child: Center(
              child: Text(
                buttonName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
