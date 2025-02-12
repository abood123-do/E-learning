import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/pages/application/application_widgets.dart';
import 'package:login/pages/application/bloc/app_blocs.dart';
import 'package:login/pages/application/bloc/app_events.dart';
import 'package:login/pages/application/bloc/app_states.dart';

import '../../common/values/colors.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBlocs, AppState>(builder: (context, state) {
      return Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
                body: buildPage(state.index),
                bottomNavigationBar: Container(
                  width: 375.w,
                  height: 58.h,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 198, 163, 24),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.h),
                          topRight: Radius.circular(20.h)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ]),
                  child: BottomNavigationBar(
                      currentIndex: state
                          .index, //هي انو إذا كبست على زر الهوم أو زر البحث أو اي زر يحط عليه لوه أزرق
                      onTap: (value) {
                        context.read<AppBlocs>().add(TriggerAppEvent(value));
                      },
                      elevation: 0,
                      type: BottomNavigationBarType.fixed, //شريط التنقل السفلي
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      selectedItemColor: AppColors.primaryElement,
                      unselectedItemColor: AppColors.primaryFourElementText,
                      items: bottomTabs),
                ))),
      );
    });
  }
}
