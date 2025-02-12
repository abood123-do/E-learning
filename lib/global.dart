import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/common/service/storage_service.dart';
import 'package:login/core/shared/local_network.dart';

import 'routes/bloc_observer.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = MyGlobalObserver();

    await CashNetwork.cashInitialization();
    storageService = await StorageService().init();
  }
}
