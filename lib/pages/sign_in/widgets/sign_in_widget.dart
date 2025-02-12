import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login/common/values/colors.dart';
import 'package:login/core/animation/dialogs/dialogs.dart';
import 'package:login/pages/sign_in/cubit/sign_in_cubit.dart';

AppBar buildAppBar(String state) {
  return AppBar(
    bottom: PreferredSize(
      //هي مشان كلمة (لوغ إن) يلي فوق براس الصفحة
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: AppColors.primarySecondaryBackground,
        //height defines the thickness of the line
        height: 1.0,
      ),
    ),
    title: Text(
      "Log In",
      style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal),
    ),
  );
}

//we need context for accessing bloc
Widget buildThirdPartyLogin(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
    padding: EdgeInsets.only(left: 25.w, right: 25.w),
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceAround, //هي بتحطلي مسافات بين الأيقونات
      children: [
        _reusableIcons("google"),
        _reusableIcons("apple"),
        _reusableIcons("facebook")
      ],
    ),
  );
}

Widget _reusableIcons(String iconName) {
  return GestureDetector(
    onTap: () {},
    child: SizedBox(
      width: 40.w,
      height: 40.w,
      child: Image.asset("assets/icons/$iconName.png"),
    ),
  );
}

Widget reusableText(String text) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 1.h,
    ),
    child: Text(
      text,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.sp),
    ),
  );
}

Widget buildTextField(
    String hintText,
    String textType,
    IconData icon,
    TextEditingController controller,
    String? Function(String?)? validator,
    bool obscureText) {
  return SizedBox(
    width: 325.w,
    height: 80.h,
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      validator: validator,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            size: 20.h,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryFourElementText)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryFourElementText)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryFourElementText)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryFourElementText)),
          hintStyle:
              const TextStyle(color: AppColors.primarySecondaryElementText)),
      style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: "Avenir",
          fontWeight: FontWeight.normal,
          fontSize: 14.sp),
      autocorrect: false,
      obscureText: obscureText,
    ),
  );
}

Widget forgotPassowrd() {
  return Container(
    margin: EdgeInsets.only(left: 25.w),
    width: 260.w,
    height: 44.h,
    child: GestureDetector(
      onTap: () {},
      child: Text("Forgot password?",
          style: TextStyle(
              color: AppColors.primaryText,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryText,
              fontSize: 12.sp)),
    ),
  );
}

Widget buildLogInAdnRegButton(String buttonName, String buttonType,
    void Function()? func, SignInCubit signInCubit) {
  return BlocConsumer<SignInCubit, SignInState>(
    listener: (context, state) {
      if (state is SignInFailedState) {
        errorDialog(context: context, text: state.errorMessage);
      } else if (state is SignInSuccessState) {
        signInCubit.signIn(context: context);
      }
    },
    builder: (context, state) {
      return state is SignInLoadingState && buttonType == "login"
          ? SpinKitFadingCircle(
              color: AppColors.primaryElement,
              size: 20.w,
            )
          : GestureDetector(
              onTap: func,
              child: Container(
                width: 325.w,
                height: 50.h,
                margin: EdgeInsets.only(
                    left: 25.w,
                    right: 25.w,
                    top: buttonType == "login" ? 40.h : 20.h),
                decoration: BoxDecoration(
                    color: buttonType == "login"
                        ? AppColors.primaryElement
                        : AppColors.primaryBackground,
                    borderRadius: BorderRadius.circular(15.w),
                    border: Border.all(
                        //التحقق من زر تسجيل الدخول (اللون)
                        color: buttonType == "login"
                            ? Colors.transparent
                            : AppColors.primaryFourElementText),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.1))
                    ]),
                child: Center(
                  child: Text(
                    buttonName,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: buttonType == "login"
                            ? AppColors.primaryBackground
                            : AppColors.primaryText),
                  ),
                ),
              ),
            );
    },
  );
}
