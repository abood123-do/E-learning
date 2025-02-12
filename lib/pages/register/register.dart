import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/pages/register/widgets/sign_up_button_widget.dart';
import 'package:login/pages/register/widgets/user_type_button_widget.dart';
import 'package:login/utils/validate_input.dart';

import '../sign_in/widgets/sign_in_widget.dart';
import 'cubit/register_cubit.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();
    final Validate validate = Validate(context: context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar("Sign Up"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: Form(
          key: registerCubit.formKey,
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
              buildTextField(
                "Enter user name",
                "user name",
                Icons.person,
                registerCubit.nameController,
                validate.validateUsername,
                false,
              ),
              buildTextField(
                "Enter your email",
                "email",
                Icons.email,
                registerCubit.emailController,
                validate.validateEmail,
                false,
              ),
              buildTextField(
                "Enter your password",
                "password",
                Icons.password_sharp,
                registerCubit.passwordController,
                validate.validatePassword,
                true,
              ),

              buildTextField(
                "Confirm your password",
                "repeat password",
                Icons.lock,
                registerCubit.confirmPasswordController,
                (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Please confirm your password';
                  } else if (p0 != registerCubit.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                true,
              ),

              SizedBox(height: 20.h),
              Text(
                "Register as:",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              const Row(
                children: [
                  UserTypeButtonWidget(label: "Teacher", value: "teacher"),
                  UserTypeButtonWidget(label: "Student", value: "student"),
                ],
              ),

              SizedBox(height: 30.h),

              const SignUpButtonWidget(),
            ],
          ),
        ),
      ),
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
