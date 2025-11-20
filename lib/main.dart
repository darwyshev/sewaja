// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://aaaiczsguvewfsrugvhl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhYWljenNndXZld2ZzcnVndmhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2NDM3OTUsImV4cCI6MjA3OTIxOTc5NX0.HQIAhDO1KTnRXWb_eYSeqBs2727pBwcB88ZYNOnjRaw',
  );
  runApp(MyApp());
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