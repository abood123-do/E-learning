import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25.w),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomePageText(
              "Hello,",
              color: AppColors.primaryThreeElementText,
            ),
          ),
          SliverToBoxAdapter(
            child: HomePageText(
              "abd",
              color: AppColors.primaryText,
              top: 5,
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 20.h)),
          SliverToBoxAdapter(
            child: searchView(),
          ),
          // SliverToBoxAdapter(
          //   child: slidersView(context, state),
          // ),
          SliverToBoxAdapter(
            child: courseStatisticsWidget(courseCount: 20, studentCount: 25),
          )
        ],
      ),
    );
  }
}
