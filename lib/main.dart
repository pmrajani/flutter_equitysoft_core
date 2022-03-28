import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'theme/themes.dart';
import 'view/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Equitysoft HRM",
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      defaultTransition: Transition.cupertino,
      home: const HomeScreen(),
    );
  }
}
