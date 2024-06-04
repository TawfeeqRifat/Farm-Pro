import 'dart:async';
import 'dart:convert' show json;

import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:farm_pro/sample_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farm_pro/pages/HomePage.dart';
import 'package:farm_pro/services/AuthService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body:
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VerticalPadding(paddingSize: 230),

              Stack(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffe1f1e4),
                    ),

                  ),
                  Positioned(
                    left: -3,
                    top: -3,
                    child: IconButton(onPressed: ()=>AuthService().signInWithGoogle(),
                      icon: Image.network('https://lh3.googleusercontent.com/COxitqgJr1sJnIDe8-jiKhxDx1FrYbtRHKJ9z_hELisAlapwE9LUPh6fcXIfb5vwpbMl4xl9H9TRFPc5NOO8Sb3VSgIBrfRYvW6cUA',
                        fit: BoxFit.contain,
                        height: 50,
                      ),),
                  )
                ],
              ),
              const VerticalPadding(paddingSize: 30),

              ElevatedButton(onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context)=> HomePage(detail: details)));
              }, child:
              Text('Guest Login',
                style: TextStyle(
                  color: lightTeal,
                ),),

              )

            ],
          ),
        ),
      );
    }
}
