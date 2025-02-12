import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/pages/register/cubit/register_cubit.dart';

import '../../../common/values/colors.dart';

class SignUpButtonWidget extends StatelessWidget {
  const SignUpButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // الانتقال إلى الصفحة المناسبة بناءً على نوع المستخدم
          if (registerCubit.formKey.currentState!.validate()) {
            await registerCubit.signUp(context: context);
          }
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
}
