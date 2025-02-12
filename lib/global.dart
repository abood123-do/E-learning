import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/common/routes/bloc_observer.dart';
import 'package:login/common/service/storage_service.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = MyGlobalObserver(); //المراقب عم يراقب عمل كلشي بلوكات
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBZGRtNQpZDKmtFqCo4Z3wqPtVEU_ui_0I",
            authDomain: "login-f99f2.firebaseapp.com",
            projectId: "login-f99f2",
            storageBucket: "login-f99f2.firebasestorage.app",
            messagingSenderId: "809552355803",
            appId: "1:809552355803:web:385c62a380b40ef51a47fe")

        //options: DefaultFirebaseOptions.currentPlatform,
        );
    storageService = await StorageService().init();
  }
}
