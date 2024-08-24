import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'Pages/Authentication_pages/SignUpForm.dart';
import 'Utilities/CustomWidgets.dart';
import 'Utilities/custom.dart';

//pop-up message window
Future PopUp(context,message,double? fontsize,Color? fontcolor,FontWeight? fontweight,String? ButtonText){
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: myBackground),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(message,style: GoogleFonts.lato(
                      fontSize: fontsize ?? 30,
                      color: fontcolor ?? Colors.redAccent,
                      fontWeight: fontweight?? FontWeight.w400,),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                VerticalPadding(paddingSize: 20),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
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
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          color: myBackground,
                          fontSize: 30,
                        ),
                        child: Text(
                          ButtonText ?? 'Okay',
                          textAlign: TextAlign.center,
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

//finish setting up Pop Up
Future<void> createAccountPopUp(context) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: myBackground),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: DefaultTextStyle(
                      style: GoogleFonts.lato(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    child: const Text(
                      'Finish Setting Up?',
                      textAlign: TextAlign.center,
                    )
                  )
                ),
                const VerticalPadding(paddingSize: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SignUpForm()));
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: darkerGreen),
                    child: Center(
                      child: DefaultTextStyle(
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          color: myBackground,
                          fontSize: 30,
                        ),
                        child: const Text(
                          'Continue',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future loadAnimation(context){
  //loading widget
  return showDialog(context: context, builder: (context){
    return Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: Colors.teal,
        size: 70,
      ),
    );
  });
}