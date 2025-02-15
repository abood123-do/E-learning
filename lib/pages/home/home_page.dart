import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:login/core/shimmer/course_shimmer.dart';
import 'package:login/model/course_model.dart';
import 'package:login/pages/home/cubit/home_cubit.dart';
import 'package:login/pages/home/widgets/home_page_widgets.dart';
import 'package:login/utils/check_role.dart';
import '../../core/animation/dialogs/dialogs.dart';
import '../home_teacher/add_course_screen.dart';
import '../home_teacher/cubits/create_course_cubit/create_course_cubit.dart';

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
    final userRole = CashNetwork.getCashData(key: 'role');
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      // appBar: buildAppBar(/*userProfile.avatar.toString()*/),
      floatingActionButton: checkTeacherRole()
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => CreateCourseCubit(
                        homeCubit: homeCubit,
                      ),
                      child: AddCoursePage(),
                    ),
                  ),
                );
              },
              backgroundColor: AppColors.primaryElement,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25.w),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: const SizedBox(),
                expandedHeight: !checkTeacherRole()
                    ? mediaQuery.height / 2.2
                    : mediaQuery.height / 1.5,
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
                        Row(
                          children: [
                            HomePageText(CashNetwork.getCashData(key: 'role'),
                                color: AppColors.primaryElement, top: 5),
                            HomePageText(
                                " ${CashNetwork.getCashData(key: 'user_name')}",
                                color: AppColors.primaryText,
                                top: 5),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        slidersView(context, homeCubit),
                        !checkTeacherRole()
                            ? const SizedBox()
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  BlocConsumer<HomeCubit, HomeState>(
                                    listener: (context, state) {
                                      // TODO: implement listener
                                    },
                                    builder: (context, state) {
                                      return courseStatisticsWidget(
                                          courseCount:
                                              homeCubit.allCourses.length,
                                          studentCount:
                                              homeCubit.allCourses.length);
                                    },
                                  )
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeDeleteLoadingState) {
                loadingDialog(context: context, mediaQuery: mediaQuery);
              } else if (state is HomeSuccessState) {
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
                  SizedBox(
                    height: mediaQuery.height / 90,
                  ),
                  searchView(homeCubit.searchController, homeCubit),
                  menuView(role: userRole),
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
                        onLongPress: () {
                          if (!checkTeacherRole()) {
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Confirm Deletion"),
                                content: Text(
                                    "Do you want to delete this course ('${item.title}')?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await homeCubit.deleteCourse(
                                          currentCourse: item,
                                          context: context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
