import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:farm_pro/Pages/Authentication_pages/signInPage.dart';
import 'package:farm_pro/Pages/Authentication_pages/signUpPage.dart';
import 'package:farm_pro/pages/HomePage.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  void initState(){
    super.initState();
    // _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    bool showLoginPage=false;
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            //user is logged in
            if(snapshot.hasData){
                return HomePage();
               // return example(detail: detail);
            }
            else{
              return LoginorRegister();
            }
          }
      )
    );
  }
}

class LoginorRegister extends StatefulWidget {
  const LoginorRegister({super.key});

  @override
  State<LoginorRegister> createState() => _LoginorRegisterState();
}

class _LoginorRegisterState extends State<LoginorRegister> {

  bool showLoginPage=true;

  //toggle pages
  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return SignInPage(
          triggerSignUp: togglePages
      );
    }
    else{
      return SignUpPage(
        triggerSignIn: togglePages,
      );
    }
  }
}


