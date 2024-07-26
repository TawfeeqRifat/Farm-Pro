
import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/transcoder/v1.dart';

import '../Utilities/custom.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key,required this.user});
  final user;
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final nameController = TextEditingController();
  final idController = TextEditingController();


  final user= FirebaseAuth.instance.currentUser;
  late final _detailsRef;

  @override
  void initState(){
    super.initState();
    nameController.text = user?.displayName ?? ' ';

    _detailsRef = FirebaseDatabase.instance.ref('details');

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          VerticalPadding(paddingSize: 50),

          //profile
          Stack(
            alignment: Alignment.center,

            fit: StackFit.passthrough,
            children: [
              Positioned(left: 24,child: CircleAvatar(backgroundColor: myGreen,radius: 45,)),
              Icon(CupertinoIcons.person_crop_circle_badge_plus,size: 90, color: darkerGreen,),
              SizedBox(width: 120,)
            ],
          ),

          VerticalPadding(paddingSize: 40),

          //name
          CustomTextBox(controller: nameController,hintText: user?.email   ?? 'hi',Title: 'Name',),

          //id
          CustomTextBox(controller: idController,Title: "ID",),

          Spacer(),

          //Submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: () async {
                await _detailsRef.update({
                  idController.text : {
                    "name" : nameController.text,
                    "farmer?" : false,
                    "id" : idController.text,
                    "rated" : {
                      null: 0
                    },
                    "rating" : {
                      "noOfRating" : 0,
                      "rate" : 0
                    },
                    "mailId" : user?.email,
                    "profile" : user?.photoURL??'https://dunked.com/assets/prod/22884/p17s2tfgc31jte13d51pea1l2oblr3.png'
                  }
                }).catchError((error)=>print("error: $error"));
                print("works");
                Navigator.pop(context);
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: myBackground,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),

          VerticalPadding(paddingSize: 50),

        ],
      ),
    );
  }
}

class CustomTextBox extends StatefulWidget {
    CustomTextBox({
    super.key,
      this.hintText,
    required this.controller,
    this.errorText,
    this.errorCondition,
    this.optionalCondition, required this.Title,
  });
  final String? hintText;
  final String Title;
  final TextEditingController controller;
  final String? errorText;
  bool? errorCondition;
  //made for cases when to remove other TextFields error message
  bool? optionalCondition;



  @override
  State<CustomTextBox> createState() => _CustomTextBox();
}

class _CustomTextBox extends State<CustomTextBox> {

  @override
  void initState(){
    super.initState();
    widget.errorCondition=false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0,),
          child: Text(
            widget.Title,
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            onChanged: (String value){
              setState((){
                widget.errorCondition=false;
                widget.optionalCondition=false;
              });
            },

            controller: widget.controller,

            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: darkerGreen)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade100)
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent.shade100)
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent.shade100)
              ),
              fillColor: Colors.green.shade50,
              filled: true,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.lato(
                // color: Colors.green.shade400,
                color: Colors.black
              ),
              errorText: ((widget.errorCondition!=null && widget.errorCondition==true)? widget.errorText: null)?? null,
            ),
            style: GoogleFonts.lato(
              color: Colors.green.shade700,

            ),
            cursorColor: Colors.teal,
            showCursor: true,
          ),
        ),
        VerticalPadding(paddingSize: 20),
      ],
    );
  }
}


