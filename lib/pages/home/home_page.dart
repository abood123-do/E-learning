import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/core/shimmer/course_shimmer.dart';
import 'package:login/model/course_model.dart';
import 'package:login/pages/home/cubit/home_cubit.dart';
import 'package:login/pages/home/widgets/home_page_widgets.dart';
import '../../core/animation/dialogs/dialogs.dart';

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
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      // appBar: buildAppBar(/*userProfile.avatar.toString()*/),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25.w),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: const SizedBox(),
                expandedHeight: mediaQuery.height / 2.2,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: mediaQuery.height / 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomePageText("Hello,",
                            color: AppColors.primaryThreeElementText),
                        HomePageText("abdul hadi",
                            color: AppColors.primaryText, top: 5),
                        SizedBox(
                          height: 10.h,
                        ),
                        slidersView(context, homeCubit),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeSuccessState) {
                final isLastPage = state.isReachMax;
                if (isLastPage) {
                  homeCubit.pagingController.appendLastPage(state.newCourses);
                } else {
                  final nextPageKey =
                      (homeCubit.allCourses.length ~/ homeCubit.pageSize) + 1;
                  print(
                      'the next page key is =======================> $nextPageKey');
                  homeCubit.pagingController
                      .appendPage(state.newCourses, nextPageKey);
                }
              } else if (state is HomeFailedState) {
                errorDialog(context: context, text: state.errorMessage);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  searchView(),
                  menuView(),
                  SizedBox(
                    height: mediaQuery.height / 90,
                  ),
                  Expanded(
                      child: PagedGridView<int, Course>(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.6,
                    ),
                    pagingController: homeCubit.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Course>(
                      itemBuilder: (context, item, index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/course_details',
                              arguments: {'course': item});
                        },
                        child: courseGrid(course: item),
                      ).animate().fade(
                            duration: const Duration(milliseconds: 500),
                          ),
                      noItemsFoundIndicatorBuilder: (context) =>
                          const Center(child: Text('No Data')),
                      firstPageProgressIndicatorBuilder: (context) =>
                          const CourseShimmer(),
                      newPageProgressIndicatorBuilder: (context) =>
                          const CourseShimmer(),
                    ),
                  )),
                ],
              );
            },
          ).animate().fade(
                duration: const Duration(milliseconds: 500),
              ),
        ),
      ),
    );
  }
}
