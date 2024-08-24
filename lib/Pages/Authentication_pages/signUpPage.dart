import 'package:farm_pro/Utilities/custom.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../customFunction.dart';

class SignUpPage extends StatefulWidget {
  final Function()? triggerSignIn;
  const SignUpPage({super.key,required this.triggerSignIn});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //linking the firebase for writing user initial data
  final database = FirebaseDatabase.instance.ref();
  late final _detailsRef;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final doublePasswordController = TextEditingController();

  late bool isPasswordVisible;
  late bool _passwordDontMatch;
  late bool _mailAlreadyExists;
  late bool _weakPassword;

  bool mailError=false;
  bool passwordError=false;
  bool confirmPasswordError=false;


  //error messages
  String _mailErrorMessage="";
  String _passwordErrorMessage="";
  String _confirmPasswordErrorMessage="";

  //sign up function
  void signUp()async {
    //commence create Email
    debugPrint("working here!");

    if(emailController.text.isEmpty){
      setState(() {
        _mailErrorMessage="Email Id can't be empty!";
        mailError=true;
      });
    }
    else if(passwordController.text.isEmpty){
      setState(() {
        _passwordErrorMessage="Password can't be empty";
        passwordError=true;
      });
    }
    else if(doublePasswordController.text.isEmpty){
      setState(() {
        _confirmPasswordErrorMessage="Password Can't be Empty!";
        confirmPasswordError=true;
      });
    }
    else if (doublePasswordController.text != passwordController.text) {
      setState(() {
        _confirmPasswordErrorMessage="Passwords Don\'t Match!";
        confirmPasswordError=true;
      });
    }
    else{

      // //verify email popUp
      // verifyEmailPopUp(context);

      //loading animation
      loadAnimation(context);
      try{
          final credential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          //close animation
          Navigator.of(context).pop();


          debugPrint("working here!");
        } on FirebaseAuthException catch(e){

          //close animation
          Navigator.pop(context);

          //error handling
          switch(e.code){
            case 'weak-password':
              setState(() {
                _passwordErrorMessage="Weak Password";
                passwordError=true;
              });
              break;
            case 'email-already-in-use':
              setState(() {
                _mailErrorMessage="E-Mail already in Use!";
                mailError=true;
              });
              break;
            default:
              ThrowError(e.code);
          }
        }

    }
  }
   void ThrowError(e){
     PopUp(context, "$e!", 30, Colors.redAccent, FontWeight.w400,"Okay");
   }
  @override
  void initState() {
    super.initState();
    isPasswordVisible = false;
    _passwordDontMatch = false;
    _mailAlreadyExists = false;
    _weakPassword=false;

    //firebase database for writing
    _detailsRef = database.child('details');
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(

        resizeToAvoidBottomInset: false,
        backgroundColor: myBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Center(
                  child: Column(
                    children: [


                      const VerticalPadding(paddingSize: 85),
                      Text('Lets get you stated!',
                        style: GoogleFonts.signikaNegative(
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const VerticalPadding(paddingSize: 30),


                      //mail Id widget
                      TextField(
                        onChanged: (String value){
                          setState(() {
                           mailError=false;
                          });
                        },
                        controller: emailController,
                        obscureText: false,
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
                          hintText: 'Email Id',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.green.shade400,
                          ),
                          errorText: mailError? _mailErrorMessage: null,
                        ),
                        style: GoogleFonts.lato(
                          color: Colors.green.shade700,
                        ),
                        cursorColor: Colors.teal,
                        showCursor: true,
                      ),
                      const VerticalPadding(paddingSize: 10),


                      //first password box
                      TextField(

                        onChanged: (String value){
                          setState((){
                            passwordError=false;
                          });
                        },

                        controller: doublePasswordController,
                        obscureText: true,
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
                          hintText: 'Password',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.green.shade400,
                          ),
                          errorText: passwordError? _passwordErrorMessage: null,
                        ),
                        style: GoogleFonts.lato(
                          color: Colors.green.shade700,
                        ),
                        cursorColor: Colors.teal,
                        showCursor: true,

                      ),
                      const VerticalPadding(paddingSize: 10),


                      //confirm password widget
                      TextField(
                        onChanged: (String value) {
                          setState(() {
                            confirmPasswordError=false;
                          });
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          errorText: confirmPasswordError? _confirmPasswordErrorMessage: null,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: darkerGreen)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green
                                  .shade100)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent
                                  .shade100)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent.shade100)
                          ),

                          fillColor: Colors.green.shade50,
                          filled: true,
                          hintText: 'Confirm Password',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.green.shade400,
                          ),

                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ),
                        obscureText: !isPasswordVisible,
                        style: GoogleFonts.lato(
                          color: Colors.green.shade700,
                        ),
                        cursorColor: Colors.teal,
                        showCursor: true,
                      ),
                      const VerticalPadding(paddingSize: 25),


                      //sign up button
                      GestureDetector(
                        onTap: () {
                          signUp();
                        },
                        child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                                child: Text('Sign Up',
                                  style: GoogleFonts.lato(
                                      color: myBackground,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            )
                        ),
                      ),
                      const VerticalPadding(paddingSize: 20),

                      //-------------or-------------
                      Row(
                        children: [
                          Expanded(child: CustomDivider(
                            color: Colors.green.shade900,
                          )),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text('OR',
                              style: GoogleFonts.lato(
                                  fontSize:15,
                                  color: Colors.green.shade900
                              ),
                            ),
                          ),
                          Expanded(child: CustomDivider(
                            color: Colors.green.shade900,
                          )),
                        ],
                      ),

                      const VerticalPadding(paddingSize: 20),

                      //sign up
                      GestureDetector(
                        onTap: widget.triggerSignIn,
                        child: Text('Sign In?',
                          style: GoogleFonts.lato(
                            fontSize:22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      )

                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}

Future verifyEmailPopUp(context){
  return showDialog(context: context, barrierDismissible: false,
      builder: (BuildContext context)
  {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Verification Email\nSent to You",
                    style: GoogleFonts.lato(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              VerticalPadding(paddingSize: 20),
              LoadingAnimationWidget.threeRotatingDots(
                color: Colors.teal,
                size: 70,
              ),
            ]
          )
        )
    );
  });
}

