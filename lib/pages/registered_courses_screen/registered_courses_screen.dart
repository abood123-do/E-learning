import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/widgets/base_text_widget.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:login/pages/home/widgets/home_page_widgets.dart';
import 'package:login/pages/registered_courses_screen/cubit/registered_courses_cubit.dart';

class RegisteredCoursesScreen extends StatelessWidget {
  const RegisteredCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registeredCoursesCubit = context.read<RegisteredCoursesCubit>();
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          menuView(role: CashNetwork.getCashData(key: 'role')),
          SizedBox(
            height: mediaQuery.height / 90,
          ),
          BlocConsumer<RegisteredCoursesCubit, RegisteredCoursesState>(
            listener: (context, state) {},
            builder: (context, state) {
              return registeredCoursesCubit.registeredCourses.isEmpty
                  ? const Center(
                      child: Text('No registered courses'),
                    )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 1.6,
                          ),
                          itemCount:
                              registeredCoursesCubit.registeredCourses.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/course_details',
                                  arguments: {
                                    'course': registeredCoursesCubit
                                        .registeredCourses[index]
                                  });
                            },
                            child: courseGrid(
                                course: registeredCoursesCubit
                                    .registeredCourses[index]),
                          ).animate().fade(
                                duration: const Duration(milliseconds: 500),
                              ),
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
