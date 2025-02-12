// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:login/pages/bloc/register_blocs.dart';
// import 'package:login/pages/bloc/register_states.dart';
// import 'package:login/pages/register/register_controller.dart';

// import '../sign_in/bloc/sign_in_blocs.dart';
// import '../sign_in/bloc/sign_in_events.dart';
// import '../sign_in/bloc/signin_states.dart';
// import '../sign_in/sign_in_controller.dart';
// import '../sign_in/widgets/sign_in_widget.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   State<Register> createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RegisterBlocs, RegisterStates>(
//         builder: (context, State) {
//       return Container(
//         color: Colors.white,
//         child: SafeArea(
//             child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: buildAppBar("Sign Up"),
//           body: SingleChildScrollView(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 20.h,
//               ),
//               Center(child: reusableText("Enter your details and sign up")),
//               Container(
//                 margin: EdgeInsets.only(top: 36.h),
//                 padding: EdgeInsets.only(left: 25.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     reusableText(
//                         "User name"), //هدول الثلاث أسطر مشان المربع يلي بدو يدّخل المستخدم فيه
//                     buildTextField("Enter your user name", "name", "user",
//                         (value) {
//                       context.read<SignInBloc>().add(EmailEvent(value));
//                     }),

//                     reusableText("Email"),
//                     buildTextField("Enter your email address", "email", "user",
//                         (value) {
//                       context.read<SignInBloc>().add(EmailEvent(value));
//                     }),
//                     reusableText("Password"),
//                     buildTextField("Enter your password", "password", "lock",
//                         (value) {
//                       context.read<SignInBloc>().add(PasswordEvent(value));
//                     }),
//                     reusableText("Confirm password"),
//                     buildTextField(
//                         "Enter your Confirm password", "password", "lock",
//                         (value) {
//                       context.read<SignInBloc>().add(PasswordEvent(value));
//                     })
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 25.w),
//                 //child: reusableText("Enter your details and sign up"),
//               ),
//               buildLogInAdnRegButton("Sign Up", "login", () {
//                 // Navigator.of(context).pushNamed("register");
//                 RegisterController(context: context).handleEmailRegister();
//               }),
//             ],
//           )),
//         )),
//       );
//     });
//   }
// }
//---------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/pages/bloc/register_blocs.dart';
import 'package:login/pages/bloc/register_states.dart';
import 'package:login/pages/register/register_controller.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userType = "student"; // اختيار افتراضي: طالب
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false; // متغير لتتبع حالة التحميل

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBlocs, RegisterStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar("Sign Up"),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Create Your Account",
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryElement),
                  ),
                ),
                SizedBox(height: 20.h),

                // حقول الإدخال
                buildTextField("Full Name", nameController, Icons.person),
                buildTextField("Email Address", emailController, Icons.email),
                buildTextField("Password", passwordController, Icons.lock,
                    isPassword: true),
                buildTextField(
                    "Confirm Password", confirmPasswordController, Icons.lock,
                    isPassword: true),

                // اختيار نوع المستخدم
                SizedBox(height: 20.h),
                Text(
                  "Register as:",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    buildRadioButton("Teacher", "teacher"),
                    buildRadioButton("Student", "student"),
                  ],
                ),

                SizedBox(height: 30.h),

                // زر التسجيل مع دائرة التحميل
                _isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // عرض دائرة التحميل أثناء التسجيل
                    : buildSignUpButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  // دالة إنشاء حقل الإدخال مع تصميم أفضل
  Widget buildTextField(
      String hintText, TextEditingController controller, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryElement),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: AppColors.primaryElement, width: 2)),
        ),
      ),
    );
  }

  // دالة زر التسجيل مع تصميم أفضل
  Widget buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            _isLoading = true; // تفعيل دائرة التحميل
          });

          if (passwordController.text != confirmPasswordController.text) {
            setState(() {
              _isLoading = false; // إخفاء دائرة التحميل
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Passwords do not match")));
            return;
          }

          // التأكد من إدخال جميع البيانات
          if (nameController.text.isEmpty ||
              emailController.text.isEmpty ||
              passwordController.text.isEmpty) {
            setState(() {
              _isLoading = false; // إخفاء دائرة التحميل
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please fill all fields")));
            return;
          }

          // تأخير وهمي لمحاكاة المعالجة (مثال)
          await Future.delayed(Duration(seconds: 2));

          // الانتقال إلى الصفحة المناسبة بناءً على نوع المستخدم
          if (userType == "teacher") {
            Navigator.of(context).pushNamed("homeTeacher");
          } else {
            Navigator.of(context).pushNamed("/application");
          }

          setState(() {
            _isLoading = false; // إخفاء دائرة التحميل
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryElement,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
        ),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      ),
    );
  }

  // دالة إنشاء زر تحديد نوع المستخدم
  Widget buildRadioButton(String label, String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: userType,
          activeColor: AppColors.primaryElement,
          onChanged: (newValue) {
            setState(() {
              userType = newValue.toString();
            });
          },
        ),
        Text(label, style: TextStyle(fontSize: 16.sp)),
      ],
    );
  }

  // AppBar مع تصميم أنيق
  AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.primaryElement,
      centerTitle: true,
      elevation: 3,
    );
  }
}




//---------------------------------------------------------------------------------------
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   State<Register> createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   String? userName;
//   String? email;
//   String? password;
//   String? confirmPassword;
//   String? userType; // Variable to store user type (teacher or student)

//   // Function to handle registration
//   Future<void> handleRegister() async {
//     final userData = {
//       "user_name": userName ?? "",
//       "email": email ?? "",
//       "password": password ?? "",
//       "c_password": confirmPassword ?? "",
//       "user_type": userType ?? "", // Include user type in the request
//     };

//     try {
//       final response = await http.post(
//         Uri.parse("https://example.com/api/register"), // API URL
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(userData),
//       );

//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Success: ${responseBody['message']}")),
//         );
//         if (userType == "teacher") {
//           Navigator.of(context).pushNamed("homeTeacher");
//         } else if (userType == "student") {
//           Navigator.of(context).pushNamed("/application");
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${response.body}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             title: const Text("Sign Up"),
//             backgroundColor: Colors.blue,
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(16.0.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 20.h),
//                   Center(
//                     child: Text(
//                       "Enter your details and sign up",
//                       style: TextStyle(
//                           fontSize: 18.sp, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SizedBox(height: 36.h),
//                   Text("User Name"),
//                   TextField(
//                     decoration:
//                         InputDecoration(hintText: "Enter your user name"),
//                     onChanged: (value) => userName = value,
//                   ),
//                   SizedBox(height: 16.h),
//                   Text("Email"),
//                   TextField(
//                     decoration:
//                         InputDecoration(hintText: "Enter your email address"),
//                     onChanged: (value) => email = value,
//                   ),
//                   SizedBox(height: 16.h),
//                   Text("Password"),
//                   TextField(
//                     obscureText: true,
//                     decoration:
//                         InputDecoration(hintText: "Enter your password"),
//                     onChanged: (value) => password = value,
//                   ),
//                   SizedBox(height: 16.h),
//                   Text("Confirm Password"),
//                   TextField(
//                     obscureText: true,
//                     decoration: InputDecoration(
//                         hintText: "Enter your confirm password"),
//                     onChanged: (value) => confirmPassword = value,
//                   ),
//                   SizedBox(height: 24.h),
//                   Text("Are you a:"),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: RadioListTile<String>(
//                           title: const Text("Teacher"),
//                           value: "teacher",
//                           groupValue: userType,
//                           onChanged: (value) {
//                             setState(() {
//                               userType = value;
//                             });
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         child: RadioListTile<String>(
//                           title: const Text("Student"),
//                           value: "student",
//                           groupValue: userType,
//                           onChanged: (value) {
//                             setState(() {
//                               userType = value;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 36.h),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (password == confirmPassword) {
//                         if (userType != null) {
//                           handleRegister();
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text(
//                                     "Please select if you are a teacher or a student")),
//                           );
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("Passwords do not match")),
//                         );
//                       }
//                     },
//                     child: const Text("Sign Up"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
