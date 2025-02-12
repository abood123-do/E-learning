import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/common/service/storage_service.dart';

import 'routes/bloc_observer.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = MyGlobalObserver();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBZGRtNQpZDKmtFqCo4Z3wqPtVEU_ui_0I",
            authDomain: "login-f99f2.firebaseapp.com",
            projectId: "login-f99f2",
            storageBucket: "login-f99f2.firebasestorage.app",
            messagingSenderId: "809552355803",
            appId: "1:809552355803:web:385c62a380b40ef51a47fe"));
    storageService = await StorageService().init();
  }
}
