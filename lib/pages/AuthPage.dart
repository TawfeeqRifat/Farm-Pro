import 'package:farm_pro/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farm_pro/sample_details.dart';
import 'package:farm_pro/pages/LoginPage.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            //user is logged in
            if(snapshot.hasData){
              return HomePage(detail: details);
            }
            else{
              return const LoginPage();
            }
          }
      )
    );
  }
}
