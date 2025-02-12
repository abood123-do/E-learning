import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/routes/routes.dart';
import 'package:login/global.dart';
import 'package:login/pages/application/bloc/app_blocs.dart';
import 'package:login/pages/application/bloc/app_states.dart';
import 'package:login/pages/home_teacher/home_t.dart';
import 'package:login/pages/home_teacher/page_detail_course_teacher.dart';
import 'package:login/pages/register/register.dart';
import 'package:login/pages/sign_in/sign_in.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyBZGRtNQpZDKmtFqCo4Z3wqPtVEU_ui_0I",
  //         authDomain: "login-f99f2.firebaseapp.com",
  //         projectId: "login-f99f2",
  //         storageBucket: "login-f99f2.firebasestorage.app",
  //         messagingSenderId: "809552355803",
  //         appId: "1:809552355803:web:385c62a380b40ef51a47fe")

  //     //options: DefaultFirebaseOptions.currentPlatform,
  //     );
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppPages.allBlocProviders(context).cast<SingleChildWidget>(),
      child: ScreenUtilInit(
        //designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                  // iconTheme: IconThemeData(color: AppColors.primaryText),
                  elevation: 0,
                  backgroundColor: Colors.white)),
          //home: const ApplicationPage(),
          //هي بتاخدني على الصفحة الرئيسية بعد تسجيل الدخول
          // initialRoute: "/",
          //home: const Welcome(), //هي بتاخدني على صفحة تسجيل الدخول
          onGenerateRoute: AppPages.GenerateRouteSettings,

          routes: {
            //هي بتخلي أنو لما أوصل على الصفحة الثالثة وأعمل ستارت بياخدني على الصفحة اللي بعدها وما عاد في زر رجوع
            "myHomePage": (context) => const MyHomePage(),
            "signIn": (context) => const SignIn(),
            "register": (context) => const Register(),
            // "pageST": (context) => const PageST(),
            "homeTeacher": (context) => HomeTeacher(),
            "coursedetailTeacher": (context) => CourseDetailteacher(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Flutter Demo Home page"),
      ),
      body: Center(child: BlocBuilder<AppBlocs, AppState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              /* Text(
                "${BlocProvider.of<AppBlocs>(context).state.counter}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),*/
            ],
          );
        },
      )),
      /* floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: "heroTag1",
            onPressed: () =>
                BlocProvider.of<AppBlocs>(context).add(Increment()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: "heroTag2",
            onPressed: () =>
                BlocProvider.of<AppBlocs>(context).add(Decrement()),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),*/
    );
  }
}
