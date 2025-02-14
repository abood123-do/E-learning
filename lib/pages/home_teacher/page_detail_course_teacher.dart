//هي للأستاذ
import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/common/widgets/base_text_widget.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/model/course_model.dart';
import 'package:login/pages/course/course_detail_controller.dart';
import 'package:login/pages/home_teacher/cubits/answers_cubit/answers_cubit.dart';
import 'package:login/pages/home_teacher/cubits/create_chapter_cubit/create_chapter_cubit.dart';
import 'package:login/pages/home_teacher/detail_course_teacher.dart';
import 'package:login/utils/check_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailteacher extends StatefulWidget {
  const CourseDetailteacher({super.key});

  @override
  State<CourseDetailteacher> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetailteacher> {
  late CourseDetailController _courseDetailController;
  late List<String> videoList;

  @override
  void initState() {
    super.initState();
    videoList = [
      "Introduction to Course",
      "Lesson 1: Basics",
      "Lesson 2: Advanced Topics",
      "Lesson 3: Final Review"
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _courseDetailController = CourseDetailController(context: context);
    _courseDetailController.init();
  }

  void showVideos(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Videos"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.play_circle_outline),
                  title: Text(videoList[index]),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPage(videoTitle: videoList[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void navigateToAddChapter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddChapterPage(
          onConfirm: (chapterName) {
            setState(() {
              videoList.add(chapterName); // Add the chapter name to the list
            });
            Navigator.pop(
                context); // Return to the previous page after confirming
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
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
                    thumbNail(''),
                    SizedBox(height: 15.h),
                    reusbaleSubTitletext("Course Description"),
                    SizedBox(height: 15.h),
                    descriptionText(''),
                    SizedBox(height: 20.h),
                    courseSummaryTitle(),
                    courseSummaryView(
                        context,
                        Course(
                            id: 1,
                            title: 'title',
                            image: 'image',
                            hours: 1,
                            isRegistered: false,
                            levelId: 1,
                            createdAt: DateTime.now(),
                            sessions: [],
                            updatedAt: DateTime.now())),
                    SizedBox(height: 15.h),
                    //reusbaleSubTitletext("Lesson List"),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        showVideos(context);
                      },
                      child: courseLessonList(),
                    ),
                    SizedBox(height: 20.h),
                    // Add Chapter button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // Text color
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5, // Add shadow
                      ),
                      onPressed: () {
                        navigateToAddChapter(context);
                      },
                      child: Text(
                        "Add Chapter",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddChapterPage extends StatefulWidget {
  final Function(String) onConfirm;

  const AddChapterPage({super.key, required this.onConfirm});

  @override
  _AddChapterPageState createState() => _AddChapterPageState();
}

class _AddChapterPageState extends State<AddChapterPage> {
  @override
  Widget build(BuildContext context) {
    final createChapterCubit = context.read<CreateChapterCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Chapter",
        ),
        backgroundColor: AppColors.primaryElement,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: createChapterCubit.formKey,
          child: Column(
            children: [
              // Improved input field
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'this field is required';
                  }
                  return null;
                },
                controller: createChapterCubit.chapterController,
                decoration: InputDecoration(
                  labelText: "Chapter Name",
                  labelStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await createChapterCubit.pickVideo(context);
                },
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Video"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<CreateChapterCubit, CreateChapterState>(
                listener: (context, state) {
                  if (state is CreateChapterLoadingState) {
                    loadingDialog(
                        context: context,
                        mediaQuery: MediaQuery.of(context).size);
                  } else if (state is CreateChapterFailedState) {
                    Navigator.pop(context);
                    errorDialog(context: context, text: state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return state is CreateChapterPickVideoState
                      ? const Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : createChapterCubit.sessionVideo == null
                          ? const SizedBox()
                          : Container(
                              color: Colors.black,
                              height: 300.h,
                              width: double.infinity,
                              child: Chewie(
                                controller:
                                    createChapterCubit.chewieController!,
                              ),
                            );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (createChapterCubit.formKey.currentState!.validate()) {
                    await createChapterCubit.createSession(context: context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 40.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5, // Add shadow6
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoTitle;

  const VideoPage({Key? key, required this.videoTitle}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoTitle),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            height: 200,
            width: double.infinity,
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
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
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                        child: Text("Edit"),
                      ),
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
      // bottomInsetPadding: MediaQuery.of(context).viewInsets.bottom,
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

// استيراد صفحة عرض الاختبار

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key? key}) : super(key: key);

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  List<Map<String, dynamic>> questions = List.generate(
    3,
    (index) => {
      "question": TextEditingController(text: "Question ${index + 1}"),
      "options": List.generate(4, (i) => TextEditingController()),
      "correctAnswer": 0,
    },
  );

  void submitQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPreviewPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Quiz"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: questions[index]['question'],
                            decoration: InputDecoration(
                              labelText: "Question ${index + 1}",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Column(
                            children: List.generate(
                              4,
                              (optionIndex) => Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Row(
                                  children: [
                                    Radio<int>(
                                      value: optionIndex,
                                      groupValue: questions[index]
                                          ['correctAnswer'],
                                      activeColor: Colors.blueAccent,
                                      onChanged: (value) {
                                        setState(() {
                                          questions[index]['correctAnswer'] =
                                              value!;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: questions[index]['options']
                                            [optionIndex],
                                        decoration: InputDecoration(
                                          labelText:
                                              "Option ${String.fromCharCode(65 + optionIndex)}",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Submit Quiz",
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPreviewPage extends StatelessWidget {
  List<Map<String, dynamic>> quizData = [
    {
      "question": "What is Flutter primarily used for?",
      "options": [
        "Web Development",
        "Mobile App Development",
        "Game Development",
        "Data Analysis"
      ],
      "correctAnswer": "Mobile App Development"
    },
    {
      "question": "Which programming language is used by Flutter?",
      "options": ["Java", "Dart", "Python", "Swift"],
      "correctAnswer": "Dart"
    },
    {
      "question": "What is the name of Flutter's rendering engine?",
      "options": ["Skia", "WebKit", "Blink", "Gecko"],
      "correctAnswer": "Skia"
    },
    {
      "question":
          "Which widget is used to create a scrollable list in Flutter?",
      "options": ["ListView", "Column", "Row", "Container"],
      "correctAnswer": "ListView"
    },
    {
      "question": "What is the command to create a new Flutter project?",
      "options": [
        "flutter create",
        "flutter new",
        "flutter start",
        "flutter init"
      ],
      "correctAnswer": "flutter create"
    },
    {
      "question": "Which widget is used to create a button in Flutter?",
      "options": [
        "FlatButton",
        "RaisedButton",
        "TextButton",
        "All of the above"
      ],
      "correctAnswer": "All of the above"
    },
    {
      "question": "What is the purpose of the 'pubspec.yaml' file in Flutter?",
      "options": [
        "To define dependencies",
        "To configure the app's UI",
        "To write Dart code",
        "To define app permissions"
      ],
      "correctAnswer": "To define dependencies"
    },
    {
      "question": "Which command is used to run a Flutter app?",
      "options": [
        "flutter run",
        "flutter start",
        "flutter execute",
        "flutter launch"
      ],
      "correctAnswer": "flutter run"
    },
    {
      "question": "What is the main building block of a Flutter UI?",
      "options": ["Widgets", "Functions", "Classes", "Packages"],
      "correctAnswer": "Widgets"
    },
    {
      "question":
          "Which widget is used to create a text input field in Flutter?",
      "options": ["TextField", "TextFormField", "InputField", "Both A and B"],
      "correctAnswer": "Both A and B"
    },
    {
      "question": "What is the purpose of the 'setState' method in Flutter?",
      "options": [
        "To update the UI",
        "To fetch data",
        "To navigate between screens",
        "To define routes"
      ],
      "correctAnswer": "To update the UI"
    },
    {
      "question": "Which widget is used to create a grid layout in Flutter?",
      "options": ["GridView", "Column", "Row", "Stack"],
      "correctAnswer": "GridView"
    },
    {
      "question": "What is the name of Flutter's package manager?",
      "options": ["Pub", "NPM", "Pip", "Gradle"],
      "correctAnswer": "Pub"
    },
    {
      "question": "Which widget is used to create a dialog in Flutter?",
      "options": ["AlertDialog", "SimpleDialog", "Dialog", "All of the above"],
      "correctAnswer": "All of the above"
    },
    {
      "question": "What is the purpose of the 'BuildContext' in Flutter?",
      "options": [
        "To locate widgets in the tree",
        "To manage state",
        "To handle user input",
        "To define routes"
      ],
      "correctAnswer": "To locate widgets in the tree"
    },
    {
      "question":
          "Which widget is used to create a tabbed interface in Flutter?",
      "options": ["TabBar", "TabView", "TabController", "All of the above"],
      "correctAnswer": "All of the above"
    },
    {
      "question": "What is the purpose of the 'MaterialApp' widget in Flutter?",
      "options": [
        "To define the app's theme",
        "To provide navigation",
        "To manage state",
        "All of the above"
      ],
      "correctAnswer": "All of the above"
    },
    {
      "question":
          "Which widget is used to create a circular progress indicator in Flutter?",
      "options": [
        "CircularProgressIndicator",
        "LinearProgressIndicator",
        "ProgressBar",
        "Spinner"
      ],
      "correctAnswer": "CircularProgressIndicator"
    },
    {
      "question": "What is the purpose of the 'Navigator' in Flutter?",
      "options": [
        "To manage routes",
        "To handle state",
        "To create animations",
        "To fetch data"
      ],
      "correctAnswer": "To manage routes"
    },
    {
      "question": "Which widget is used to create a dropdown menu in Flutter?",
      "options": [
        "DropdownButton",
        "PopupMenuButton",
        "MenuButton",
        "SelectButton"
      ],
      "correctAnswer": "DropdownButton"
    }
  ];

  QuizPreviewPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final answerCubit = context.read<AnswersCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Preview"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: BlocConsumer<AnswersCubit, AnswersState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                SizedBox(
                  height: 525.h,
                  child: ListView.builder(
                    itemCount: quizData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Q${index + 1}: ${quizData[index]['question']}",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.h),
                              Column(
                                children: List.generate(
                                  quizData[index]['options'].length,
                                  (optionIndex) => ListTile(
                                    leading: checkTeacherRole()
                                        ? Icon(
                                            quizData[index]['options']
                                                        [optionIndex] ==
                                                    quizData[index]
                                                        ['correctAnswer']
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: quizData[index]['options']
                                                        [optionIndex] ==
                                                    quizData[index]
                                                        ['correctAnswer']
                                                ? Colors.green
                                                : Colors.grey,
                                          )
                                        : Radio(
                                            value: quizData[index]['options']
                                                [optionIndex],
                                            groupValue:
                                                answerCubit.answers[index],
                                            onChanged: (value) async {
                                              await answerCubit.selectAnswer(
                                                  value, index);
                                            },
                                          ),
                                    title: Text(
                                      quizData[index]['options'][optionIndex],
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                      elevation: 5,
                    ),
                    onPressed: () {
                      if (!answerCubit.checkAnswers()) {
                        warningDialog(
                          context: context,
                          text:
                              'There is some questions need your answer\nDo you want to submit?',
                          onPressedSubmit: () {
                            Navigator.pop(context);
                            quizDialog(
                                context: context,
                                mark: answerCubit.submit(quizData));
                          },
                        );
                      } else {
                        quizDialog(
                            context: context,
                            mark: answerCubit.submit(quizData));
                      }
                    },
                    child: const Text(
                      "Submit Quiz",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
