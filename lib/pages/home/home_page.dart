import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/pages/home/cubit/home_cubit.dart';

import 'package:login/pages/home/widgets/home_page_widgets.dart';

//import '../../common/entities/entities.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      // appBar: buildAppBar(/*userProfile.avatar.toString()*/),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25.w),
        child: CustomScrollView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          slivers: [
            SliverToBoxAdapter(
              child: HomePageText("Hello,",
                  color: AppColors.primaryThreeElementText),
            ),
            SliverToBoxAdapter(
              child: HomePageText("abdul hadi",
                  color: AppColors.primaryText, top: 5),
            ),
            SliverPadding(padding: EdgeInsets.only(top: 20.h)),
            SliverToBoxAdapter(
              child: searchView(),
            ),
            SliverToBoxAdapter(
              child: slidersView(context, homeCubit),
            ),
            SliverToBoxAdapter(
              child: menuView(),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 0.w),
              sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(childCount: 4,
                      (BuildContext context, int index) {
                    return GestureDetector(
                      //من هنا نريد أن نتمكن من الانتقال إلى صفحة جديدة
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/course_details', arguments: {});
                      },
                      child: courseGrid(),
                    );
                  }),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.6)),
            )
          ],
        ),
      ),
    );
  }
}
