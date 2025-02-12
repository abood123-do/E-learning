import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/pages/home/cubit/home_cubit.dart';

import '../../common/values/colors.dart';
import '../home/widgets/home_page_widgets.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
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
          SliverToBoxAdapter(
            child: slidersView(context, homeCubit),
          ),
          SliverToBoxAdapter(
            child: courseStatisticsWidget(courseCount: 20, studentCount: 25),
          )
        ],
      ),
    );
  }
}
