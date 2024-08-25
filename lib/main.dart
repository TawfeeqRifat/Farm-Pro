import 'package:farm_pro/firebase_options.dart';
import 'package:farm_pro/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Pages/Authentication_pages/AuthPage.dart';
import 'Pages/Authentication_pages/SignUpForm.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'farm-pro',
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
      initialRoute: '/',
      routes: {
        '/homepage' : (context) => HomePage(),
        '/signUpForm' : (context) => SignUpForm(),
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
          //colorScheme: ColorScheme.fromSeed(seedColor: darkTeal),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5FFF7),
        /*cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Colors.green,
        ),*/
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.teal,
        )
      ),

      home: const AuthPage(),
    );
  }
}

