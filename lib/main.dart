import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/global.dart';

import 'package:login/routes/routes.dart';

Future<void> main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        )),
        initialRoute: "/",
        routes: routes,
      ),
    );
  }
}
