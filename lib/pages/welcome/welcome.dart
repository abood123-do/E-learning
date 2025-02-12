import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/pages/welcome/cubit/welcome_cubit.dart';
import 'package:login/pages/welcome/widgets/page_widget.dart';

// ignore: must_be_immutable
class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final welcomeCubit = context.read<WelcomeCubit>();
    return Container(
      color: Colors.white,
      child: Scaffold(
          body: BlocConsumer<WelcomeCubit, WelcomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            margin:
                EdgeInsets.only(top: 34.h), //هي مشان تحت البار من الشاشة فوق
            width: 375.w,
            child: Stack(
              alignment: Alignment.topCenter, //خليت النقاط يصيرو تحت الزر
              children: [
                PageView(
                    controller: welcomeCubit.pageController,
                    onPageChanged: (index) {
                      welcomeCubit.changePage(index);
                    },
                    children: const [
                      PageWidget(
                          index: 1,
                          buttonName: "Next",
                          title: "First see Learning",
                          subTitle:
                              "Forget about a for of paper all knowldget in on learning",
                          imagePath: "assets/images/reading.png"),
                      PageWidget(
                          index: 2,
                          buttonName: "Next",
                          title: "Connect With Everyone",
                          subTitle:
                              "Always keep in touch with your tutor & friend. let's get connected!",
                          imagePath: "assets/images/boy.png"),
                      PageWidget(
                          index: 3,
                          buttonName: "get started",
                          title: "Always Fascinated Learning",
                          subTitle:
                              "Anywhere, anytime. The time is at our discrtion so study whenver you want",
                          imagePath: "assets/images/man.png"),
                    ]),
                Positioned(
                  //هدول بيجو تحت الزر حسب وين أنا بأي صفحة(نقاط)
                  bottom: 85.h,
                  child: DotsIndicator(
                    position: welcomeCubit.pageIndex,
                    //هاد مشان يغير النقاط مع تغير الصفحات الأولى والثانية والثالثة
                    dotsCount: 3,
                    mainAxisAlignment: MainAxisAlignment.center,
                    decorator: DotsDecorator(
                        color: AppColors.primaryThreeElementText,
                        activeColor: AppColors.primaryElement,
                        size: const Size.square(8.0),
                        activeSize: const Size(18.0, 8.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                )
              ],
            ),
          );
        },
      )),
    );
  }
}
