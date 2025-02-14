import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:login/common/service/storage_service.dart';
import 'package:login/core/shared/local_network.dart';
import 'package:login/model/course_model.dart';
import 'package:login/model/session_model.dart';

import 'routes/bloc_observer.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = MyGlobalObserver();
    await CashNetwork.cashInitialization();
    await Hive.initFlutter();
    Hive.registerAdapter(CourseAdapter());
    Hive.registerAdapter(SessionAdapter());
    await Hive.openBox('main');
    storageService = await StorageService().init();
  }
}
