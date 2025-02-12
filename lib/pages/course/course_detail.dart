import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/widgets/base_text_widget.dart';
import 'package:login/model/course_model.dart';
import 'package:login/model/session_model.dart';
import 'package:login/pages/course/course_detail_controller.dart';
import 'package:login/pages/course/cubits/video_cubit/video_cubit.dart';
import 'package:login/pages/course/widgets/show_videos_dialog.dart';
import 'package:login/pages/home_teacher/detail_course_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  //first big image
                  thumbNail(),
                  SizedBox(
                    height: 15.h,
                  ),
                  //three buttons or menus
                  // menuView(),
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
                  //course description title
                  reusbaleSubTitletext("Course Description"),
                  SizedBox(
                    height: 6.h,
                  ),
                  //course description
                  descriptionText(course.description!),
                  SizedBox(
                    height: 20.h,
                  ),
                  //course buy button

                  // course summary
                  courseSummaryTitle(),
                  //course summary in list
                  courseSummaryView(context),
                  SizedBox(
                    height: 15.h,
                  ),
                  registrCourse("registration", context),
                  SizedBox(
                    height: 15.h,
                  ),
                  //Lesson list title
                  // reusbaleSubTitletext("Lesson List"),
                  SizedBox(
                    height: 20.h,
                  ),
                  //Course lesson list
                  GestureDetector(
                    onTap: () {
                      showVideos(context);
                    },
                    child: courseLessonList(),
                  ),
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

  String currentUser = "User"; // اسم المستخدم الافتراضي
  String userAvatar = "https://via.placeholder.com/150"; // صورة افتراضية

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  // تحميل التعليقات من SharedPreferences
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

  // حفظ التعليقات إلى SharedPreferences
  Future<void> _saveComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("comments", json.encode(comments));
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(editingIndex == null ? "Enter Comment" : "Edit Comment"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter your comment",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
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
                    }
                    editingIndex = null;
                    commentController.clear();
                  });
                  _saveComments();
                  Navigator.pop(context);
                }
              },
              child: Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                commentController.clear();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.video),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          BlocConsumer<VideoCubit, VideoState>(
            listener: (context, state) {},
            builder: (context, state) {
              print('the current state is => $state');
              return state is VideoLoadingState
                  ? Text('loading')
                  : Container(
                      color: Colors.black,
                      height: 300.h,
                      width: double.infinity,
                      child: Chewie(
                        controller: videoCubit.chewieController!,
                      ),
                    );
            },
          ),
          SizedBox(height: 20),
          // ترتيب الأزرار بجانب بعضها باستخدام Row
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       ElevatedButton(
          //         onPressed: showCommentDialog,
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Colors.blueAccent,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          //         ),
          //         child: Text("Write Comment"),
          //       ),
          //       SizedBox(width: 20), // مسافة بين الأزرار
          //       // ElevatedButton(
          //       //   onPressed: navigateToCreateQuizPage, // زر إنشاء اختبار
          //       //   style: ElevatedButton.styleFrom(
          //       //     backgroundColor: Colors.green, // اللون الأخضر
          //       //     shape: RoundedRectangleBorder(
          //       //       borderRadius: BorderRadius.circular(10),
          //       //     ),
          //       //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          //       //   ),
          //       //   child: Text("Create Quiz"),
          //       // ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 20),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: comments.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         leading: CircleAvatar(
          //           backgroundImage: NetworkImage(comments[index]["avatar"]!),
          //         ),
          //         title: Text(comments[index]["name"]!),
          //         subtitle: Text(comments[index]["comment"]!),
          //         trailing: PopupMenuButton<int>(
          //           onSelected: (value) {
          //             if (value == 0) {
          //               setState(() {
          //                 editingIndex = index;
          //                 commentController.text = comments[index]["comment"]!;
          //               });
          //               showCommentDialog();
          //             } else if (value == 1) {
          //               setState(() {
          //                 comments.removeAt(index);
          //               });
          //               _saveComments();
          //             }
          //           },
          //           itemBuilder: (context) => [
          //             PopupMenuItem(
          //               value: 0,
          //               child: Text("Edit"),
          //             ),
          //             PopupMenuItem(
          //               value: 1,
          //               child: Text("Delete"),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}

// class QuizPage extends StatefulWidget {
//   const QuizPage({Key? key}) : super(key: key);

//   @override
//   State<QuizPage> createState() => _QuizPageState();
// }

// class _QuizPageState extends State<QuizPage> {
//   int score = 0;
//   List<int?> selectedAnswers = List.filled(10, null);

//   List<Map<String, dynamic>> questions = [
//     {
//       "question": "What is Flutter?",
//       "options": ["A framework", "A programming language", "An IDE"],
//       "answer": 0
//     },
//     {
//       "question": "Who developed Flutter?",
//       "options": ["Google", "Facebook", "Microsoft"],
//       "answer": 0
//     },
//     // Add more questions here (total 10)
//   ];

//   void submitQuiz() {
//     if (selectedAnswers.contains(null)) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Incomplete Quiz"),
//             content: Text("Please answer all questions before submitting."),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       score = 0;
//       for (int i = 0; i < questions.length; i++) {
//         if (selectedAnswers[i] == questions[i]['answer']) {
//           score++;
//         }
//       }
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Quiz Result"),
//             content: Text("Your score is: $score"),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text("Close"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Quiz"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: questions.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(questions[index]['question']),
//                       ...List.generate(
//                         questions[index]['options'].length,
//                         (optionIndex) => RadioListTile<int>(
//                           title: Text(questions[index]['options'][optionIndex]),
//                           value: optionIndex,
//                           groupValue: selectedAnswers[index],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedAnswers[index] = value;
//                             });
//                           },
//                         ),
//                       )
//                     ],
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: submitQuiz,
//               child: Text("Submit Quiz"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
