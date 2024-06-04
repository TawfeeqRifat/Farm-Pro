import 'package:farm_pro/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:farm_pro/pages/AuthPage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
        //colorScheme: ColorScheme.fromSeed(seedColor: darkTeal),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5FFF7),
      ),

      home: const AuthPage(),
    );
  }
}

