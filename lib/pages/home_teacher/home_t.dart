import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:login/pages/home/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_page.dart';
import '../profile/cubits/profile_cubit/profile_cubit.dart';
import '../profile/profile.dart';

class HomeTeacher extends StatefulWidget {
  const HomeTeacher({super.key});

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends State<HomeTeacher> {
  int _index = 0;
  final List<Widget> _pages = [
    BlocProvider(
      create: (context) => HomeCubit()..initState(context),
      child: const HomePage(),
    ),
    BlocProvider(
      create: (context) => ProfileCubit(),
      child: const ProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: _pages[_index],
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
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
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
                      '/course_detail_teacher',
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
