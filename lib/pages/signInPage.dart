import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:farm_pro/pages/signUpPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  final Function()? triggerSignUp;
  const SignInPage({super.key, required this.triggerSignUp});
  //onTap;
  @override
  State<SignInPage> createState() => _SignInPageState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Function()?>.has('onTap', triggerSignUp));
  }
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  //for text
  final emailController= TextEditingController();
  final passwordController = TextEditingController();
  late bool isPasswordVisible;
  bool wrongPassword=false;
  bool wrongMail=false;
  //for loading circle
  //late AnimationController _animationController;
  //late Animation<Color?> _colorTween;

  @override
  void initState(){
    super.initState();

    isPasswordVisible=false;/*
    _animationController=AnimationController(
      vsync: this,);
    _colorTween= _animationController.drive(
      ColorTween(
        begin: Colors.green,
        end: Colors.teal,
      ));
    _animationController.repeat(
    );*/



  }

  void signIn()async{
    setState(() async {
      print(emailController.text);
      debugPrint(passwordController.text);
      await  FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      print('signed in ${FirebaseAuth.instance.currentUser?.displayName!}');
    });

    //loading circle
    // showDialog(context: context, builder: (context){
    //   return Center(
    //       child: CircularProgressIndicator(
    //         strokeCap: StrokeCap.round,
    //         //valueColor: _colorTween,
    //       )
    //   );
    // });


    //commence sign in
    /*try{
      await  FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      //print(FirebaseAuth.instance.username);
      //close loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      //close loading circle
      Navigator.pop(context);
      debugPrint('error');
      //mail no found
      if(e.code =='user-not-found'){
        setState((){
          wrongMail=true;
        });
      }

      //incorrect password
      else if(e.code=='wrong-password'){
        setState((){
          wrongPassword
          =true;
        });
      }
    }*/

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
                    const VerticalPadding(paddingSize: 95),
                    Container(
                        child: Text('FarmPro',
                          style: GoogleFonts.signikaNegative(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        )
                    ),
                    const VerticalPadding(paddingSize: 30),
          
                    //mail Id widget
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email Id',
                      obscureText: false,
                      errorText: 'Email Not Found!',
                      errorCondition: wrongMail
                    ),
                    const VerticalPadding(paddingSize: 10),
          
                    //password widget
                    TextField(
                        //onChanged: onQueryChanged,
                        onChanged: (String Value){
                          setState(() {
                            wrongPassword=false;
                          });
                        },
                        controller: passwordController,
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

                          errorText: wrongPassword?'Incorrect Password':null,

          
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                isPasswordVisible=!isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isPasswordVisible?Icons.visibility_rounded:Icons.visibility_off_rounded,
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
          
                    const VerticalPadding(paddingSize: 4),
          
                    //forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: (){
                            },
                            child: Text('Forgot Password?',
                              style: GoogleFonts.lato(
                                color: Colors.green.shade900,
                                fontSize:14,
                              ),
                            ),
                        ),
                      ],
                    ),
                    const VerticalPadding(paddingSize: 20),
          
                    //sign in button
                    GestureDetector(
                      onTap: signIn,
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text('Sign In',
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
                      onTap: widget.triggerSignUp,
                      child: Text('Sign Up?',
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

class MyTextField extends StatefulWidget {
  MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.errorText,
    this.errorCondition,
    this.optionalCondition
  });
  final bool obscureText;
  final String hintText;
  final TextEditingController controller;
  final String? errorText;
  bool? errorCondition;
  //made for cases when to remove other TextFields error message
  bool? optionalCondition;



  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  @override
  void initState(){
    super.initState();
    widget.errorCondition=false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        onChanged: (String value){
          setState((){
            widget.errorCondition=false;
            widget.optionalCondition=false;
          });
        },

        controller: widget.controller,
        obscureText: widget.obscureText,
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
            color: Colors.green.shade400,
          ),
          errorText: ((widget.errorCondition!=null && widget.errorCondition==true)? widget.errorText: null)?? null,
          ),
        style: GoogleFonts.lato(
          color: Colors.green.shade700,
        ),
        cursorColor: Colors.teal,
        showCursor: true,
    );
  }
}


