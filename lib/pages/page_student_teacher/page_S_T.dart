// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:login/common/values/colors.dart';
// import 'package:login/pages/sign_in/bloc/sign_in_blocs.dart';
// import 'package:login/pages/sign_in/bloc/signin_states.dart';
// import 'package:login/pages/sign_in/widgets/sign_in_widget.dart';

// class PageST extends StatefulWidget {
//   const PageST({super.key});

//   @override
//   State<PageST> createState() => _PageSTState();
// }

// class _PageSTState extends State<PageST> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SignInBloc, SigninState>(
//       builder: (context, state) {
//         return Container(
//           color: Colors.white,
//           child: SafeArea(
//               child: Scaffold(
//             backgroundColor: Colors.white,
//             body: SingleChildScrollView(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                     child: Text(
//                   "You must choose",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 25,
//                     height: 6.h,
//                   ),
//                 )),
//                 Container(
//                   margin: EdgeInsets.only(top: 36.h),
//                   padding: EdgeInsets.only(left: 25.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                   ),
//                 ),
//                 buildLogInAdnRegButton("Student", "login", () {
//                   Navigator.of(context).pushNamed("/application");
//                   //SignInController(constext: context).handleSignIn("Email");
//                 }),
//                 buildLogInAdnRegButton("teacher", "login", () {
//                   Navigator.of(context).pushNamed("homeTeacher");
//                 }),
//               ],
//             )),
//           )),
//         );
//       },
//     );
//   }
// }
