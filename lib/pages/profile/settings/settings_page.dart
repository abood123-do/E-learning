import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login/common/routes/names.dart';
import 'package:login/common/values/constant.dart';
import 'package:login/global.dart';
import 'package:login/pages/application/bloc/app_events.dart';
import 'package:login/pages/home/bloc/home_page_blocs.dart';
import 'package:login/pages/home/bloc/home_page_events.dart';
import 'package:login/pages/profile/settings/bloc/settings_blocs.dart';
import 'package:login/pages/profile/settings/bloc/settings_states.dart';

import '../../application/bloc/app_blocs.dart';
import 'widgets/settings_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void removeUserData() {
    //ملاحظة نحن نستخدم const لأنها توفر مساحة الذاكرة وتصحح الأخطاء
    context.read<AppBlocs>().add(const TriggerAppEvent(
        0)); //هي لما اعمل تسجيل جخول ياخدني على صفحة الهوم
    context.read<HomePageBlocs>().add(const HomePageDots(0));
    Global.storageService.remove(AppConstants.STORAGE_USER_TOKEN_KEY);
    Global.storageService.remove(
        //هون رح يزيل كل شي لما اعمل تسجيل خروج
        AppConstants.STORAGE_USER_PROFILE_KEY);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.SING_IN, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
          child: BlocBuilder<SettingsBlocs, SettingsStates>(
        builder: (context, State) {
          return Container(
            child: Column(children: [settingsButton(context, removeUserData)]),
          );
        },
      )),
    );
  }
}
