import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';

import '../../../common/values/colors.dart';

void loadingDialog(
    {required BuildContext context,
    required Size mediaQuery,
    String title = ''}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitFadingCircle(
            color: AppColors.primaryElement,
            size: mediaQuery.width / 30,
          ),
          SizedBox(
            height: mediaQuery.height / 90,
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryElement,
            ),
          ),
        ],
      ),
    ),
  );
}

void internetToast({
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('No Internet'),
  ));
}

void serverToast({
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Server is down'),
  ));
}

void internetDialog({required BuildContext context, required Size mediaQuery}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage('assets/images/logo.png'),
            fit: BoxFit.contain,
            width: mediaQuery.width / 3,
            height: mediaQuery.height / 5,
          ),
          const Text(
            'Please connect to internet',
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryElement,
            ),
          ),
        ],
      ),
    ),
  );
}

void errorDialog({
  required BuildContext context,
  required String text,
}) {
  const textStyle =
      TextStyle(color: AppColors.primaryElement, fontWeight: FontWeight.w600);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Error',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      content: Text(text),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              AppColors.primaryElement.withOpacity(0.1),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('close', style: textStyle),
        ),
      ],
    ),
  );
}

void internetErrorDialog({
  required BuildContext context,
  required String text,
}) {
  const textStyle =
      TextStyle(color: AppColors.primaryElement, fontWeight: FontWeight.w600);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'حدث خطأ في الاتصال',
        style: TextStyle(
            color: AppColors.primaryElement, fontWeight: FontWeight.bold),
      ),
      content: Text(text),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              AppColors.primaryElement.withOpacity(0.1),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('إغلاق', style: textStyle),
        ),
      ],
    ),
  );
}

void SaveEditDialog({
  required BuildContext context,
  required void Function()? onPressedCancel,
  required void Function()? onPressedSave,
}) {
  const textStyle =
      TextStyle(color: AppColors.primaryElement, fontWeight: FontWeight.w600);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'تنبيه',
        style: TextStyle(
            color: AppColors.primaryElement, fontWeight: FontWeight.bold),
      ),
      content: Text(
        'يوجد تعديلات لم تقم بحفظها بعد\nهل تريد الحفظ؟',
        // textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.transparent,
            ),
          ),
          onPressed: onPressedCancel,
          child: Text('إغلاق', style: textStyle),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              AppColors.primaryElement.withOpacity(0.1),
            ),
          ),
          onPressed: onPressedSave,
          child: Text('حفظ', style: textStyle),
        ),
      ],
    ),
  );
}

void showToast({
  required BuildContext context,
  required String text,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      // timeInSecForIosWeb: 1,

      backgroundColor: Colors.red,
      textColor: Colors.white,
    );

void infoDialog({
  required BuildContext context,
  required String text,
}) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.info,
    text: text,
    confirmBtnColor: Colors.amber.shade400,
  );
}

void successDialog({
  required BuildContext context,
  required String text,
}) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    text: text,
    confirmBtnColor: Colors.green,
  );
}

void showExpiredDialog(
    {required BuildContext context,
    required void Function()? onConfirmBtnTap}) {
  QuickAlert.show(
      context: context,
      disableBackBtn: false,
      barrierDismissible: false,
      type: QuickAlertType.error,
      text:
          'Your session has expired due to inactivity.\nPlease log in again to continue.',
      confirmBtnText: 'ok',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: onConfirmBtnTap);
}

void noInternetDialog(
    {required BuildContext context,
    required Size mediaQuery,
    required void Function()? onPressed}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white70,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/no_internet.json',
            fit: BoxFit.contain,
            width: mediaQuery.width / 5,
            height: mediaQuery.height / 5,
          ),
          const Text(
            'Please make sure that you have Internet connection and try again',
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryElement,
            ),
          ),
          ElevatedButton(
              onPressed: onPressed,
              child: const Text(
                'Try again',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    ),
  );
}
