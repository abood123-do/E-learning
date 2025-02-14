import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/widgets/base_text_widget.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:login/core/shimmer/video_shimmer.dart';
import 'package:login/model/course_model.dart';
import 'package:login/model/session_model.dart';
import 'package:login/pages/course/course_detail_controller.dart';
import 'package:login/pages/course/cubits/course_details_cubit/course_details_cubit.dart';
import 'package:login/pages/course/cubits/script_cubit/script_cubit.dart';
import 'package:login/pages/course/cubits/session_comment_cubit/session_comment_cubit.dart';
import 'package:login/pages/course/cubits/video_cubit/video_cubit.dart';
import 'package:login/pages/course/script_screen.dart';
import 'package:login/pages/course/widgets/show_videos_dialog.dart';
import 'package:login/pages/home_teacher/cubits/create_chapter_cubit/create_chapter_cubit.dart';
import 'package:login/pages/home_teacher/detail_course_teacher.dart';
import 'package:login/utils/check_role.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../home_teacher/cubits/answers_cubit/answers_cubit.dart';
import '../home_teacher/page_detail_course_teacher.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({super.key});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  late CourseDetailController _courseDetailController;
  late List<String> videoList;
  List<String> comments = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _courseDetailController = CourseDetailController(context: context);
    _courseDetailController.init();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Course course = args['course'];
    final courseDetailCubit = context.read<CourseDetailsCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  thumbNail(course.image),
                  SizedBox(
                    height: 15.h,
                  ),
                  reusbaleSubTitletext("Course Name"),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    course.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  reusbaleSubTitletext("Course Description"),
                  SizedBox(
                    height: 6.h,
                  ),
                  descriptionText(course.description!),
                  SizedBox(
                    height: 20.h,
                  ),
                  courseSummaryTitle(),
                  BlocConsumer<CourseDetailsCubit, CourseDetailsState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return courseSummaryView(context, course);
                    },
                  ),
                  checkTeacherRole()
                      ? const SizedBox()
                      : Column(
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            registrCourse("registration", context, course),
                          ],
                        ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      (course.isRegistered ||
                                  courseDetailCubit.checkIsRegister(
                                      isRegister: course.isRegistered,
                                      course: course)) ||
                              checkTeacherRole()
                          ? showVideos(
                              context, course.sessions, courseDetailCubit)
                          : errorDialog(
                              context: context,
                              text:
                                  'You have to be registered at this course to can access the sessions');
                    },
                    child: courseLessonList(),
                  ),
                  !checkTeacherRole()
                      ? const SizedBox()
                      : Column(
                          children: [
                            SizedBox(height: 20.h),
                            // Add Chapter button
                            SizedBox(
                              width: 900.w,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue, // Text color
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5, // Add shadow
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => CreateChapterCubit(
                                            courseDetailsCubit:
                                                courseDetailCubit,
                                            currentCourse: course),
                                        child: AddChapterPage(
                                          onConfirm: (chapterName) {},
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Add Chapter",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final Session session;

  const VideoPage({Key? key, required this.session}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
    final sessionCommentCubit = context.read<SessionCommentCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.sessionTitle),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocConsumer<VideoCubit, VideoState>(
            listener: (context, state) {},
            builder: (context, state) {
              print('the current state is => $state');
              return state is VideoLoadingState
                  ? const VideoShimmer()
                  : Container(
                      color: Colors.black,
                      height: 200.h,
                      width: double.infinity,
                      child: Chewie(
                        controller: videoCubit.chewieController!,
                      ),
                    );
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            width: 900.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, // Text color
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5, // Add shadow
              ),
              onPressed: () {
                if (checkTeacherRole()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ScriptCubit(),
                        child: const ScriptScreen(),
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => AnswersCubit(),
                        child: QuizPreviewPage(),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "Start Quiz",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          BlocConsumer<SessionCommentCubit, SessionCommentState>(
            listener: (context, state) {
              if (state is SessionCommentFailedState) {
                errorDialog(context: context, text: state.errorMessage);
              }
            },
            builder: (context, state) {
              return SizedBox(
                height: 310.h,
                child: ListView.builder(
                  itemCount: sessionCommentCubit.allComments.length,
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      enabled: state is SessionCommentLoadingState,
                      child: sessionCommentCubit.allComments.isNotEmpty &&
                              sessionCommentCubit
                                      .allComments[index].courseSessionId !=
                                  widget.session.id
                          ? const SizedBox()
                          : ListTile(
                              leading: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/icons/02.png'),
                              ),
                              title: const Text(
                                'Default user',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  sessionCommentCubit.allComments.isEmpty
                                      ? 'the is the default comment'
                                      : sessionCommentCubit
                                          .allComments[index].note),
                              trailing:
                                  sessionCommentCubit.allComments.isNotEmpty &&
                                          sessionCommentCubit
                                                  .allComments[index].userId
                                                  .toString() !=
                                              CashNetwork.getCashData(
                                                      key: 'user_id')
                                                  .toString()
                                      ? const SizedBox()
                                      : PopupMenuButton<int>(
                                          onSelected: (value) {
                                            if (value == 1) {
                                              sessionCommentCubit.deleteComment(
                                                  context: context,
                                                  comment: sessionCommentCubit
                                                      .allComments[index]);
                                            }
                                          },
                                          itemBuilder: (context) => const [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        ),
                            ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: sessionCommentCubit.commentController,
                focusNode: sessionCommentCubit.commentFocusNode,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            ),
            const SizedBox(width: 10),
            BlocConsumer<SessionCommentCubit, SessionCommentState>(
              listener: (context, state) {
                if (state is SessionCommentCrudLoadingState) {
                  loadingDialog(
                      context: context,
                      mediaQuery: MediaQuery.of(context).size,
                      title: 'Loading...');
                } else if (state is SessionCommentCrudFailedState) {
                  Navigator.pop(context);
                  errorDialog(context: context, text: state.errorMessage);
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () async {
                    await sessionCommentCubit.createComment(
                        context: context, sessionId: widget.session.id);
                  },
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
