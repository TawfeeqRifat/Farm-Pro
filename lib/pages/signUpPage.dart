import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:farm_pro/pages/signInPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../sample_details.dart';
class SignUpPage extends StatefulWidget {
  final Function()? triggerSignIn;
  const SignUpPage({super.key,required this.triggerSignIn});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final doublePasswordController = TextEditingController();

  late bool isPasswordVisible;
  late bool _passwordDontMatch;
  late bool _mailAlreadyExists;
  late bool _weakPassword;

  //sign up function
  void signUp()async {
    //commence create Email
    debugPrint("working here!");
    try{
      final credential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      );
      debugPrint("working here!");
    } on FirebaseAuthException catch(e){

      //weak password
      if(e.code == 'weak-password'){
        setState(() {
          _weakPassword=true;
        });
      }

      //email taken already
      else if(e.code=='email-already-taken-in-use'){
        _mailAlreadyExists=true;
      }

      else(e){
        showDialog(context: context,
            builder: (BuildContext){
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: Text(e,style: GoogleFonts.lato(fontWeight: FontWeight.w500)),
                    ),
                    TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('OK'))
                  ],
                ),
              );
            });
      };
    }
  }
  @override
  void initState() {
    super.initState();
    isPasswordVisible = false;
    _passwordDontMatch = false;
    _mailAlreadyExists = false;
    _weakPassword=false;
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
                            _mailAlreadyExists=false;
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
                          errorText: _mailAlreadyExists? 'Mail Already Taken!': null,
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
                            _passwordDontMatch=false;
                            _weakPassword=false;
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
                          errorText: _weakPassword?'Weak Password': null,
                        ),
                        style: GoogleFonts.lato(
                          color: Colors.green.shade700,
                        ),
                        cursorColor: Colors.teal,
                        showCursor: true,

                      ),
                      const VerticalPadding(paddingSize: 10),


                      //password widget
                      TextField(
                        onChanged: (String value) {
                          setState(() {
                            _passwordDontMatch = false;
                          });
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          errorText: _passwordDontMatch
                              ? 'Passwords Don\'t Match!'
                              : null,
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
                          hintText: 'Password',
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


                      //sign in button
                      GestureDetector(
                        onTap: () async{
                            print('clicking');
                            if (doublePasswordController.text != passwordController.text) {
                              setState(() {
                                _passwordDontMatch = true;
                              });
                            }
                            else{
                              try{
                                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text
                                ).then((userCredential)=>{
                                  debugPrint('logged in')

                                });
                              }
                              on FirebaseAuthException catch(e) {
                                print(e);
                              }
                            }
                           /* Iterable<String> allUsers = details.keys;
                            List<String> allMails = [];
                            for (var i in allUsers) {
                              dynamic nowUser = details[i]?['contact_details'];
                              if (nowUser != null &&
                                  nowUser.containsKey('mail_id')) {
                                allMails.add(nowUser['mail_id']);
                              }
                            }
                            if (allMails.contains(emailController.text)) {
                              _mailAlreadyExists = true;
                            }*/


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


