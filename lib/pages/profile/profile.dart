import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/common/values/constant.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:login/global.dart';
import 'package:login/model/user_model.dart';
import 'package:login/pages/profile/cubits/profile_cubit/profile_cubit.dart';

import 'package:login/pages/profile/cubits/settings_cubit/settings_cubit.dart';
import 'package:login/utils/validate_input.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void removeUserData() {
    Global.storageService.remove(AppConstants.STORAGE_USER_TOKEN_KEY);
    Global.storageService.remove(
        //هون رح يزيل كل شي لما اعمل تسجيل خروج
        AppConstants.STORAGE_USER_PROFILE_KEY);
    Navigator.of(context).pushNamedAndRemoveUntil('/sign_in', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
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
            BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                User userData = Hive.box('main').get('user');

                return Column(
                  children: [
                    Text(
                      userData.name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData.email,
                      style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                    ),
                  ],
                );
              },
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
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          SettingsCubit(profileCubit: profileCubit)
                            ..initState(),
                      child: const SettingsPage(),
                    ),
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
              onPressed: () async {
                await Hive.box('main').clear();
                await CashNetwork.clearCash();
                Phoenix.rebirth(context);
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
    final settingsCubit = context.read<SettingsCubit>();
    final validator = Validate(context: context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppColors.primaryElement,
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoadingState) {
            loadingDialog(
                context: context, mediaQuery: MediaQuery.of(context).size);
          } else if (state is SettingsFailedState) {
            errorDialog(context: context, text: state.errorMessage);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: settingsCubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "New username",
                      style: TextStyle(
                          fontSize: 16.sp, color: AppColors.primaryElement),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[800]!, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      validator: validator.validateUsername,
                      controller: settingsCubit.usernameController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Enter your username"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "User Email",
                      style: TextStyle(
                          fontSize: 16.sp, color: AppColors.primaryElement),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[800]!, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      validator: validator.validateEmail,
                      controller: settingsCubit.userEmailController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Enter your username"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // حقل كلمة المرور
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 16.sp, color: AppColors.primaryElement),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[800]!, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      validator: validator.validatePassword,
                      controller: settingsCubit.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration.collapsed(
                          hintText: "Enter new password"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // زر تأكيد التغيير
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (settingsCubit.formKey.currentState!.validate()) {
                          await settingsCubit.updateData(context: context);
                        }
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
        },
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
        title: const Text("Your Certificates"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.h),
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: const Image(
                  image: AssetImage('assets/images/certificate.jpg')),
            )
          ],
        ),
      ),
    );
  }
}
