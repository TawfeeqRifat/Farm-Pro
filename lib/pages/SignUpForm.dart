
import 'dart:async';

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
  const SignUpForm({super.key});
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final nameController = TextEditingController();
  final idController = TextEditingController();

  //get user details from google
  final user= FirebaseAuth.instance.currentUser;
  //get firebase link to write
  late final _detailsRef;

  //get firebase link to constant reading
  dynamic _firebaseDetails;
  final ref = FirebaseDatabase.instance.ref();

  late StreamSubscription _detailsStream;
  List<dynamic> _allIds=[];
  void _getDetails() async {

    //active fetching
    _detailsStream=ref.child('details').onValue.listen((event){
      setState(() {
        _firebaseDetails=event.snapshot.value;
        _allIds=_firebaseDetails.keys.toList();
        print(_allIds);
      });
    });
  }

  //error handling kinda
  bool nameError=false;
  bool idError=false;
  String nameErrorText='';
  String idErrorText='';
  bool checkCaps(){
    String  pattern = '[A-Z]';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(idController.text);
  }
  void createAccount() async {
    if(nameController.text.isEmpty){
      setState(() {
        nameErrorText= "Name can't be empty!";
        nameError=true;
      });
    }
    else if( nameController.text.length<4){
      setState(() {
        nameErrorText= "Name can't be less than 4 characters!";
        nameError=true;
      });
    }

    else if(idController.text.isEmpty){
      setState(() {
        idErrorText="ID can't be empty!";
        idError=true;
      });
    }
    else if(idController.text.length<4){
      setState(() {
        idErrorText="ID can't be less than 4 characters!";
        idError=true;
      });
    }
    else if(idController.text.contains(' ')){
      setState(() {
        idErrorText="ID can't contain empty space!";
        idError=true;
      });
    }
    else if(checkCaps()){
      setState(() {
        idErrorText="ID can't contain capital letter!";
        idError=true;
      });
    }
    else if(_allIds.contains(idController.text)){
      setState(() {
        idErrorText="ID already exists! Enter a Unique Id!";
        idError=true;
      });
    }
    else{
      bool success=true;
      await _detailsRef.update({
        idController.text : {
          "name" : nameController.text,
          "farmer?" : false,
          "id" : idController.text,
          "official_mail" : user?.email,
          "rated" : {
            null: 0
          },
          "rating" : {
            "noOfRating" : 0,
            "rate" : 0
          },
          "profile" : user?.photoURL??'https://dunked.com/assets/prod/22884/p17s2tfgc31jte13d51pea1l2oblr3.png'
        }
      }).catchError((error){print("error: $error");success=false;});
      if(success){
        return showDialog
          (context: context,
            builder: (BuildContext context){
              return Center(
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: myBackground
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultTextStyle(
                        child: Text(
                          'Your Account \nhas been set!',
                          textAlign: TextAlign.center,
                        ),
                        style: GoogleFonts.lato(
                          fontSize: 38,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const VerticalPadding(paddingSize: 20),

                      GestureDetector(
                        onTap: (){
                          Navigator.popAndPushNamed(context, '/homepage');
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: darkerGreen
                          ),
                          child: Center(
                            child: DefaultTextStyle(
                              child: Text(
                                'Continue',
                                textAlign: TextAlign.center,
                              ),
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                color: myBackground,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    }
  }

  @override
  void initState(){
    super.initState();

    //assigning a name for ease of use
    nameController.text = user?.displayName ?? ' ';

    //connect firebase for write
    _detailsRef = FirebaseDatabase.instance.ref('details');

    //connect firebase for contant read
    _getDetails();

  }

  @override
  void deactivate(){
    super.deactivate();
    _detailsStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            VerticalPadding(paddingSize: 40),

            //title
            Text(
              'Finish Setting Up',
              style: GoogleFonts.signikaNegative(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
            ),
            VerticalPadding(paddingSize: 40),

            //profile
            GestureDetector(
              onTap: (){

              },
              child: Stack(
                alignment: Alignment.center,

                fit: StackFit.passthrough,
                children: [
                  Positioned(left: 24,child: CircleAvatar(backgroundColor: myGreen,radius: 45,)),
                  Icon(CupertinoIcons.person_crop_circle_badge_plus,size: 90, color: darkerGreen,),
                  SizedBox(width: 120,)
                ],
              ),
            ),

            VerticalPadding(paddingSize: 25),

            //name
            // CustomTextBox(controller: nameController,Title: 'Name',errorText: "Name can't be empty and less than 4 characters!",errorCondition: nameError,helperText: '*Name should have at least 4 characters', hintText: user?.email,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,),
                  child: Text(
                    'Name',
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
                        nameError=false;
                      });
                    },

                    controller: nameController,

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

                      hintStyle: GoogleFonts.lato(
                        // color: Colors.green.shade400,
                          color: Colors.black26
                      ),
                      errorText: (nameError==true)? nameErrorText: null,
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
            ),



            //id
            // CustomTextBox(controller: idController,Title: "ID",errorText: 'ID Already Exists! Enter a Unique Id!',errorCondition: idError,helperText: '*ID can\'t contain Capital letters nor blank space',),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,),
                  child: Text(
                    'ID',
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
                        idError=false;
                      });
                    },

                    controller: idController,

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

                      hintStyle: GoogleFonts.lato(
                        // color: Colors.green.shade400,
                          color: Colors.black26
                      ),
                      errorText: (idError==true)? idErrorText : null ,
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
            ),


            // Spacer(),
            VerticalPadding(paddingSize: 45),
            //Submit button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: createAccount,
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
      this.optionalCondition,
      required this.Title,
      this.text,
      this.helperText
  });
  final String? hintText;
  final String Title;
  final TextEditingController controller;
  final String? errorText;
  final String? text;
  final String? helperText;
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
              helperText: widget.helperText?? '',

              hintStyle: GoogleFonts.lato(
                // color: Colors.green.shade400,
                color: Colors.black26
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


