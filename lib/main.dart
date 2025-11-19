// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SEWAJA',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.INTRO, // Pastikan ke INTRO dulu!
      getPages: AppPages.routes,
      theme: ThemeData(
        primaryColor: const Color(0xFFC0E862),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Ubuntu',
      ),
    );
  }
}