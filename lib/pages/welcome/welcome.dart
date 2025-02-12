import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/common/values/constant.dart';
import 'package:login/global.dart';
import 'package:login/pages/welcome/bloc/welcom_states.dart';
import 'package:login/pages/welcome/bloc/welcome_blocs.dart';
import 'package:login/pages/welcome/bloc/welcome_events.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _welcomeState();
}

class _welcomeState extends State<Welcome> {
  PageController pageController = PageController(
      initialPage:
          0); //هي كمان مشان إذا كبست على الزر ينتقل على الصفحة الثانية وينتقل كمان مع النقاط يلي تحت الزر
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(body: BlocBuilder<WelcomeBloc, WelcomState>(
        builder: (context, state) {
          return Container(
            margin:
                EdgeInsets.only(top: 34.h), //هي مشان تحت البار من الشاشة فوق
            width: 375.w,
            child: Stack(
              alignment: Alignment.topCenter, //خليت النقاط يصيرو تحت الزر
              children: [
                PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      state.page = index;
                      BlocProvider.of<WelcomeBloc>(context).add(WelcomeEvent());
                      print("index value is ${index}");
                    },
                    children: [
                      _page(
                          1,
                          context,
                          "Next",
                          "First see Learning",
                          "Forget about a for of paper all knowldget in on learning",
                          "assets/images/reading.png"),
                      _page(
                          2,
                          context,
                          "Next",
                          "Connect With Everyone",
                          "Always keep in touch with your tutor & friend. let's get connected!",
                          "assets/images/boy.png"),
                      _page(
                          3,
                          context,
                          "get started",
                          "Always Fascinated Learning",
                          "Anywhere, anytime. The time is at our discrtion so study whenver you want",
                          "assets/images/man.png"),
                    ]),
                Positioned(
                  //هدول بيجو تحت الزر حسب وين أنا بأي صفحة(نقاط)
                  bottom: 85.h,
                  child: DotsIndicator(
                    position: state.page.toInt(),
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

  Widget _page(int index, BuildContext context, String buttonName, String title,
      String subTitle, String imagePath) {
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
              //animation
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate);
            } else {
              print("-1");
              //jump to a new page
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
              Global.storageService
                  .setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME, true);
              print("0");
              print(
                  "The value is ${Global.storageService.getDeviceFirstOpen()}");
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
