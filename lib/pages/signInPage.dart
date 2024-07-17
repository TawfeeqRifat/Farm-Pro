import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController= TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible=false;

  @override
  void initState(){
    super.initState();
    isPasswordVisible=false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      backgroundColor: myBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: Column(
                  children: [
                    VerticalPadding(paddingSize: 95),
                    Container(
                        child: Text('FarmPro',
                          style: GoogleFonts.signikaNegative(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        )
                    ),
                    VerticalPadding(paddingSize: 30),
          
                    //mail Id widget
                    myTextField(
                      controller: emailController,
                      hintText: 'Email Id',
                      obscureText: false,
                    ),
                    VerticalPadding(paddingSize: 10),
          
                    //password widget
                    TextField(
                        //onChanged: onQueryChanged,
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
          
                          fillColor: Colors.green.shade50,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.green.shade400,
                          ),
          
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
          
                    VerticalPadding(paddingSize: 4),
          
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
                    VerticalPadding(paddingSize: 20),
          
                    //sign in button
                    GestureDetector(
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
                    VerticalPadding(paddingSize: 20),
          
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
                      onTap: (){},
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

class myTextField extends StatelessWidget {
  const myTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.suffix
  });
  final bool obscureText;
  final String hintText;
  final controller;
  final suffix;
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        obscureText: obscureText,
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
          fillColor: Colors.green.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.lato(
            color: Colors.green.shade400,
          ),

          ),
        style: GoogleFonts.lato(
          color: Colors.green.shade700,
        ),
        cursorColor: Colors.teal,
        showCursor: true,
    );
  }
}


