import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom.dart';
double HorizontalPadSize = 15;
double VerticalPadSize = 35;
class VerticalPadding extends StatelessWidget {
  const VerticalPadding({super.key, required this.paddingSize});
  final double paddingSize;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: paddingSize));
  }
}

class HorizontalPadding extends StatelessWidget {
  const HorizontalPadding({super.key, required this.paddingSize});
  final double paddingSize;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSize));
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key,this.color,this.thickness,this.borderRadius});
  final Color? color;
  final double? thickness;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(
          height: thickness ?? 3,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius??35),
          color: color ?? Colors.black,
        ),
      ),
        ],
      ),
    );


  }
}

//text box
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
    this.helperText,
    this.multiline,
    this.editable
  });
  final String? hintText;
  final String Title;
  final TextEditingController controller;
  final String? errorText;
  final String? text;
  final String? helperText;
  bool? errorCondition;
  bool? multiline;
  //for to make the text field editable or not
  bool? editable;
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

            enabled: widget.editable?? true,
            controller: widget.controller,
            keyboardType: (widget.multiline!=null && widget.multiline==true)? TextInputType.multiline: null,
            maxLines: (widget.multiline!=null && widget.multiline==true)? null: 1,
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

