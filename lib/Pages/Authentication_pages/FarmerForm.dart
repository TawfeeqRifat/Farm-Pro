import 'package:farm_pro/Pages/Authentication_pages/SignUpForm.dart';
import 'package:farm_pro/Pages/Profile_pages/Shop_page.dart';
import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/customFunction.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../Utilities/custom.dart';
import '../../global_variable.dart';

class Farmerform extends StatefulWidget {
  const Farmerform({super.key});

  @override
  State<Farmerform> createState() => _FarmerformState();
}

class _FarmerformState extends State<Farmerform> {

  TextEditingController DescripionController = TextEditingController();
  TextEditingController AddressController1 = TextEditingController();
  TextEditingController AddressController2 = TextEditingController();
  TextEditingController AddressController3  = TextEditingController();
  TextEditingController mailController  = TextEditingController();
  TextEditingController phoneController  = TextEditingController();

  bool mailError=false;
  bool phoneError=false;
  bool domainError=false;
  bool descriptionError=false;
  bool addressError=false;

  String commonErrorText="Should not be empty!";

  late List<TextEditingController> DomainControllers=[];

  void deleteDomain(int pos){
    setState(() {
      if(pos!=0) DomainControllers.removeAt(pos);
    });
  }

  void addDomain(){
    TextEditingController newController= TextEditingController();
      setState(() {
        DomainControllers.add(newController);
      });
  }

  Future<void> GoToShop() async {
    if(mailController.text.isEmpty){
      setState(() {
        mailError=true;
      });
      print('mail empty');
    }
    else if(phoneController.text.isEmpty){
      setState(() {
        phoneError=true;
        mailError=false;
      });
    }
    else if(DomainControllers[0].text.isEmpty){
      setState(() {
        domainError=true;
        phoneError=false;
        mailError=false;
      });
    }
    else if(DescripionController.text.isEmpty){
      setState(() {
        descriptionError=true;
        domainError=false;
        phoneError=false;
        mailError=false;
      });
    }
    else if(AddressController1.text.isEmpty){
      setState(() {
        addressError=true;
        descriptionError=false;
        domainError=false;
        phoneError=false;
        mailError=false;
      });
    }
    else{

      //load Animation
      loadAnimation(context);

      bool success=true;
      List domainVals=[];
      for(var i in DomainControllers){
        if(i.text.isNotEmpty) domainVals.add(i.text);
      }
      dynamic _userDetailsRef = FirebaseDatabase.instance.ref('details/$userId');
      await _userDetailsRef.update({
          "farmer?" : true,
          "contact_details" : {
            "mail_id" : mailController.text,
            "pno" : phoneController.text
          },
          "about" : DescripionController.text,
          "address" : AddressController1.text + "\n" + AddressController2.text + "\n" + AddressController3.text,
          "farm_type" : domainVals,
          "rating" : {
            "noOfRating" : 0,
            "rate" : 0
          },
      }
      ).catchError((e){

        //close animation
        Navigator.pop(context);

        success=false;
        PopUp(context,'$e');
      });
      if(success==true){

        //close animation
        Navigator.pop(context);

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext)=> ShopPage(ref: _userDetailsRef,mode: 'edit-mode',farmerDetails: _userDetailsRef,)));
      }
    }
  }

  @override
  void initState(){
    super.initState();
    addDomain();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalPadding(paddingSize: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Farmer',style: GoogleFonts.lato(
                color: Colors.green,
                fontWeight: FontWeight.w800,
                fontSize: 50,
              ),),
            ),
            const VerticalPadding(paddingSize: 30),


            //mail id
            CustomTextBox(controller: mailController, Title: 'Support Mail Id',errorCondition: mailError, errorText: commonErrorText,),
            //phone no
            CustomTextBox(controller: phoneController, Title: 'Support Phone No',errorCondition: phoneError,  errorText: commonErrorText,),

            //domains
            Padding(
              padding: const EdgeInsets.only(left: 20.0,),
              child: Text(
                'Domain',
                textAlign: TextAlign.left,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 120),
              child: ListView.builder(
                  itemCount: DomainControllers.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context,int index){
                    return ListTile(
                      leading: SizedBox(
                          width: 180,
                          height: 50,
                          child: TextField(
                            onChanged: (String value){
                              setState((){
                                domainError=false;
                              });
                            },

                            controller: DomainControllers[index],
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
                                  color: Colors.black26
                              ),
                              errorText: (domainError==true && index==0)? commonErrorText: null,
                              // errorText:
                            ),
                            style: GoogleFonts.lato(
                              color: Colors.green.shade700,
                            ),
                            cursorColor: Colors.teal,
                            showCursor: true,
                          )
                      ),
                      trailing: IconButton(
                        onPressed: (){deleteDomain(index);},
                        icon: Icon(CupertinoIcons.xmark),
                      ),

                    );
                  }
              ),
            ),

            Row(
              children: [

                HorizontalPadding(paddingSize: 70),
                Text(
                    'ADD',
                    style: GoogleFonts.lato(
                      color: darkerGreen,
                      fontSize: 20,
                    ),
                ),
                HorizontalPadding(paddingSize: 5),
                IconButton(
                    onPressed: addDomain,
                    icon: Icon(
                        CupertinoIcons.plus_circle,
                      color: darkerGreen,
                    )
                ),
              ],
            ),

            //description
            CustomTextBox(controller: DescripionController, Title: 'Description',multiline: 3, errorCondition: descriptionError, errorText: commonErrorText,),

            //address
            Padding(
              padding: const EdgeInsets.only(left: 20.0,),
              child: Text(
                'Address',
                textAlign: TextAlign.left,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            VerticalPadding(paddingSize: 5),
            CusTextBoxAlone(controller: AddressController1,errorCondition: addressError, errorText: commonErrorText,),
            CusTextBoxAlone(controller: AddressController2),
            CusTextBoxAlone(controller: AddressController3),

            VerticalPadding(paddingSize: 20),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right:30.0),
                  child: TextButton(
                      onPressed: (){
                        GoToShop();
                      },
                   style: ButtonStyle(
                     shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                   ),
                      child: Text(
                        'Go To Shop',
                        style: GoogleFonts.lato(
                          fontSize: 30,
                          fontWeight:FontWeight.w800,
                          color: Colors.green
                        ),
                      ),

                  ),
                ),
              ],
            ),
            VerticalPadding(paddingSize: 40),
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
    this.helperText,
    this.multiline,
  });
  final String? hintText;
  final String Title;
  final TextEditingController controller;
  final String? errorText;
  final String? text;
  final String? helperText;
  bool? errorCondition;
  int? multiline;
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
        VerticalPadding(paddingSize: 5),
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
            keyboardType: (widget.multiline!=null)? TextInputType.multiline: null,
            maxLines: (widget.multiline!=null)? widget.multiline: 1,
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
        VerticalPadding(paddingSize: 10),
      ],
    );
  }
}

class CusTextBoxAlone extends StatefulWidget {
  CusTextBoxAlone ({
    super.key,
    this.hintText,
    required this.controller,
    this.errorText,
    this.errorCondition,
    this.optionalCondition,
    this.helperText,
    this.multiline,
  });
  final String? hintText;
  final TextEditingController controller;
  final String? errorText;
  final String? helperText;
  bool? errorCondition;
  bool? multiline;
  //made for cases when to remove other TextFields error message
  bool? optionalCondition;



  @override
  State<CusTextBoxAlone> createState() => _cusTextBoxAlone ();
}

class _cusTextBoxAlone  extends State<CusTextBoxAlone> {

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
      ],
    );
  }
}


