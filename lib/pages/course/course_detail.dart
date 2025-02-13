import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/widgets/base_text_widget.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/model/course_model.dart';
import 'package:login/model/session_model.dart';
import 'package:login/pages/course/course_detail_controller.dart';
import 'package:login/pages/course/cubits/course_details_cubit/course_details_cubit.dart';
import 'package:login/pages/course/cubits/video_cubit/video_cubit.dart';
import 'package:login/pages/course/widgets/show_videos_dialog.dart';
import 'package:login/pages/home_teacher/cubits/create_chapter_cubit/create_chapter_cubit.dart';
import 'package:login/pages/home_teacher/detail_course_teacher.dart';
import 'package:login/utils/check_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  thumbNail(),
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
                            registrCourse("registration", context),
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
                      course.isRegistered || checkTeacherRole()
                          ? showVideos(context, course.sessions)
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
  List<Map<String, String>> comments = [];
  TextEditingController commentController = TextEditingController();
  int? editingIndex;
  FocusNode commentFocusNode = FocusNode();

  String currentUser = "User";
  String userAvatar = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    commentController.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedComments = prefs.getString("comments");
    if (storedComments != null) {
      setState(() {
        comments = List<Map<String, String>>.from(json
            .decode(storedComments)
            .map((item) => Map<String, String>.from(item)));
      });
    }
  }

  Future<void> _saveComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("comments", json.encode(comments));
  }

  void _addOrUpdateComment() {
    if (commentController.text.isNotEmpty) {
      setState(() {
        if (editingIndex == null) {
          comments.add({
            "name": currentUser,
            "avatar": userAvatar,
            "comment": commentController.text,
          });
        } else {
          comments[editingIndex!] = {
            "name": currentUser,
            "avatar": userAvatar,
            "comment": commentController.text,
          };
          editingIndex = null;
        }
        commentController.clear();
      });
      _saveComments();
    }
  }

  void _editComment(int index) {
    setState(() {
      editingIndex = index;
      commentController.text = comments[index]["comment"]!;
      commentFocusNode.requestFocus();
    });
  }

  void _deleteComment(int index) {
    setState(() {
      comments.removeAt(index);
    });
    _saveComments();
  }

  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
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
                  ? const Text('loading')
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
              onPressed: () {},
              child: const Text(
                "Start Quiz",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 310.h,
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comments[index]["avatar"]!),
                  ),
                  title: Text(comments[index]["name"]!),
                  subtitle: Text(comments[index]["comment"]!),
                  trailing: PopupMenuButton<int>(
                    onSelected: (value) {
                      if (value == 0) {
                        _editComment(index);
                      } else if (value == 1) {
                        _deleteComment(index);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 1,
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
            ),
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
                controller: commentController,
                focusNode: commentFocusNode,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              onPressed: _addOrUpdateComment,
              icon: Icon(Icons.send, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
