import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/routes/names.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/common/values/constant.dart';
import 'package:login/global.dart';
import 'package:login/pages/application/bloc/app_blocs.dart';
import 'package:login/pages/application/bloc/app_events.dart';
import 'package:login/pages/home/bloc/home_page_blocs.dart';
import 'package:login/pages/home/bloc/home_page_events.dart';
import 'package:login/pages/home/bloc/home_page_states.dart';
import 'package:login/pages/home/widgets/home_page_widgets.dart';
import 'package:login/pages/sign_in/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // لاستعمال ملف الصورة
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Teacher App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeTeacher(),
      routes: {
        AppRoutes.COURSE_DETAIL_TEACHER: (context) => const CourseDetailPage(),
      },
    );
  }
}

class HomeTeacher extends StatefulWidget {
  const HomeTeacher({super.key});

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends State<HomeTeacher> {
  int _index = 0; // لتحديد الصفحة النشطة في الشريط السفلي

  final List<Widget> _pages = [
    BlocBuilder<HomePageBlocs, HomePageStates>(builder: (context, state) {
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
              child: slidersView(context, state),
            ),
            SliverToBoxAdapter(
              child: courseStatisticsWidget(courseCount: 20, studentCount: 25),
            )
          ],
        ),
      );
    }),
    //Center(child: Text("البحث")),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: _pages[_index],
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCoursePage(),
                  ),
                );
              },
              backgroundColor: AppColors.primaryElement,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_file),
            label: "Courses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final courseName = args['courseName'] ?? 'No Course Name';

    return Scaffold(
      appBar: AppBar(title: const Text("Course Details")),
      body: Center(
        child: Text(
          "Details of Course: $courseName",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<String>> getCourses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('courses') ?? [];
  }

  Future<void> deleteCourse(String courseName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> courses = prefs.getStringList('courses') ?? [];

    courses.remove(courseName);
    await prefs.setStringList('courses', courses);

    setState(() {}); // تحديث الواجهة بعد الحذف
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: getCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String courseName = snapshot.data![index];

                return ListTile(
                  title: Text(courseName),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.COURSE_DETAIL_TEACHER,
                      arguments: {'courseName': courseName},
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Confirm Deletion"),
                          content: Text(
                              "Are you sure you want to delete '$courseName'?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteCourse(courseName);
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
                );
              },
            );
          }
          return const Center(child: Text("No courses found"));
        },
      ),
    );
  }
}

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseDetailsController = TextEditingController();
  final TextEditingController courseHoursController = TextEditingController();
  final TextEditingController totalLessonsController = TextEditingController();

  bool _isImageAdded = false; // لتتبع ما إذا تم إضافة صورة وهمية أم لا

  // دالة لحفظ اسم الكورس في SharedPreferences
  Future<void> saveCourseName(String courseName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> courses = prefs.getStringList('courses') ?? [];
    courses.add(courseName); // إضافة الكورس الجديد إلى المصفوفة
    await prefs.setStringList('courses', courses); // حفظ المصفوفة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Course"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildInputField(
                "Course Name", "Enter course name", courseNameController),
            buildInputField("Course Details", "Enter course details",
                courseDetailsController),
            buildInputField(
                "Course Hours", "Enter course hours", courseHoursController,
                keyboardType: TextInputType.number),
            buildInputField(
                "Total Lessons", "Enter total lessons", totalLessonsController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            // زر لإضافة صورة وهمية
            GestureDetector(
              onTap: () {
                setState(() {
                  _isImageAdded = !_isImageAdded; // تغيير الحالة عند الضغط
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      _isImageAdded ? "Image Added" : "Add Course Image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // عرض الصورة الوهمية
            if (_isImageAdded)
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: AssetImage('assets/placeholder.png'), // صورة وهمية
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (courseNameController.text.isEmpty ||
                    courseDetailsController.text.isEmpty ||
                    courseHoursController.text.isEmpty ||
                    totalLessonsController.text.isEmpty ||
                    !_isImageAdded) {
                  // تحقق من إضافة الصورة
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Please fill all fields and add an image"),
                        backgroundColor: Colors.red),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Course added successfully!"),
                      backgroundColor: Colors.green),
                );

                // حفظ اسم الكورس في SharedPreferences
                saveCourseName(courseNameController.text);

                // الانتقال إلى صفحة البحث بعد إضافة الكورس
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Confirm Addition",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
      String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[800])),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 2)),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void removeUserData() {
    //ملاحظة نحن نستخدم const لأنها توفر مساحة الذاكرة وتصحح الأخطاء
    context.read<AppBlocs>().add(const TriggerAppEvent(
        0)); //هي لما اعمل تسجيل جخول ياخدني على صفحة الهوم
    context.read<HomePageBlocs>().add(const HomePageDots(0));
    Global.storageService.remove(AppConstants.STORAGE_USER_TOKEN_KEY);
    Global.storageService.remove(
        //هون رح يزيل كل شي لما اعمل تسجيل خروج
        AppConstants.STORAGE_USER_PROFILE_KEY);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.SING_IN, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(left: 8.w),
              margin: EdgeInsets.only(left: 1.h),
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.w),
                  image: const DecorationImage(
                      image: AssetImage("assets/icons/headpic.png"))),
              child: Image(
                  width: 25.w,
                  height: 25.h,
                  image: const AssetImage("assets/icons/edit_3.png")),
            ),
            const SizedBox(height: 16),
            Text(
              "Abd",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue[800]),
              title: const Text("Settings"),
              onTap: () {
                // عند الضغط على الإعدادات ننتقل إلى صفحة الإعدادات
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.note_add, color: AppColors.primaryElement),
              title: const Text("Add notes"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotesPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Sign out",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You are logged out!"),
                    backgroundColor: Colors.green,
                  ),
                );
                // الانتقال إلى صفحة تسجيل الدخول
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}

// صفحة كتابة الملاحظات
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _noteController = TextEditingController();
  List<String> _notes = [];

  void _addNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _notes.add(_noteController.text.trim());
        _noteController.clear();
      });
    }
  }

  void _editNote(int index) {
    _noteController.text = _notes[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Edit Note"),
          content: TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: "Enter the note",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _notes[index] = _noteController.text.trim();
                });
                _noteController.clear();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: "Add a note",
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: const Text(
                "Add Note",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Text(
                        "No notes yet! Add some notes to get started.",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              _notes[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editNote(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteNote(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حقل اسم المستخدم
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "New username",
                style: TextStyle(fontSize: 16.sp, color: Colors.blue[800]),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[800]!, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: usernameController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enter your username"),
              ),
            ),
            const SizedBox(height: 16),

            // حقل كلمة المرور
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "New Password",
                style: TextStyle(fontSize: 16.sp, color: Colors.blue[800]),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[800]!, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration:
                    InputDecoration.collapsed(hintText: "Enter new password"),
              ),
            ),
            const SizedBox(height: 16),

            // زر تأكيد التغيير
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // تنفيذ التغيير هنا
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Settings changed successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context); // العودة للصفحة السابقة
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Confirm change",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // class SearchPage extends StatelessWidget {
// //   const SearchPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 16),
//             ListTile(
//               //leading: Icon(Icons.settings, color: Colors.blue[800]),
//               title: const Text("Flutter Course"),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushNamed(AppRoutes.COURSE_DETAIL_TEACHER, arguments: {
//                   //"id": state.courseItem.elementAt(index).id, //الكورسات يلي بدي مررها هون لازم يكون في إلها معرّف
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             ListTile(
//               //leading: Icon(Icons.settings, color: Colors.blue[800]),
//               title: const Text("Flutter Course"),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushNamed(AppRoutes.COURSE_DETAIL_TEACHER, arguments: {
//                   //"id": state.courseItem.elementAt(index).id, //الكورسات يلي بدي مررها هون لازم يكون في إلها معرّف
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
