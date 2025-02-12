import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/common/values/constant.dart';
import 'package:login/global.dart';

import 'package:flutter/widgets.dart';
import 'package:login/pages/home/widgets/home_page_widgets.dart';
import 'package:login/pages/sign_in/sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void removeUserData() {
    //ملاحظة نحن نستخدم const لأنها توفر مساحة الذاكرة وتصحح الأخطاء
    // context.read<AppBlocs>().add(const TriggerAppEvent(
    //     0)); //هي لما اعمل تسجيل جخول ياخدني على صفحة الهوم
    // context.read<HomePageBlocs>().add(const HomePageDots(0));
    Global.storageService.remove(AppConstants.STORAGE_USER_TOKEN_KEY);
    Global.storageService.remove(
        //هون رح يزيل كل شي لما اعمل تسجيل خروج
        AppConstants.STORAGE_USER_PROFILE_KEY);
    Navigator.of(context).pushNamedAndRemoveUntil('/sign_in', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
              leading: Icon(Icons.settings, color: AppColors.primaryElement),
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
            ListTile(
              leading: Icon(Icons.note_add, color: AppColors.primaryElement),
              title: const Text("Sertfecate"),
              onTap: () {
                // هنا نقوم بتمرير اسم المستخدم إلى صفحة الشهادة
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CertificatePage(userName: "User"), // تمرير اسم المستخدم
                  ),
                );
              },
            ),

            const Spacer(),

            // settingsButton(context, removeUserData),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryElement,
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/sign_up',
                  (route) => false,
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
        backgroundColor: AppColors.primaryElement,
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
                style:
                    TextStyle(fontSize: 16.sp, color: AppColors.primaryElement),
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
                style:
                    TextStyle(fontSize: 16.sp, color: AppColors.primaryElement),
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
                  backgroundColor: AppColors.primaryElement,
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

class CertificatePage extends StatelessWidget {
  final String userName;

  // استلام اسم المستخدم عبر الـ constructor
  const CertificatePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Certificate"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Congratulations, $userName!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "You have completed the course!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Icon(
              Icons.star,
              size: 100,
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
