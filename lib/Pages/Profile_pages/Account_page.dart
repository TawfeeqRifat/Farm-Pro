import 'package:farm_pro/customFunction.dart';
import 'package:farm_pro/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utilities/CustomWidgets.dart';
import '../../Utilities/custom.dart';

class AccountPage extends StatefulWidget {
  AccountPage({super.key, this.mode, required this.userDetails, required this.ref});
  String? mode;
  dynamic userDetails;
  final ref;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  //used with mode, indicate text box editability
  late bool editable;

  saveChanges() async {

    if(nameController.text.isEmpty){
      setState(() {
        nameError="Name can't be empty!";
        nameErrorCondition=true;
      });
      return;
    }

    bool success=true;
    var userRef= widget.ref.child('details/$userId');
    if(widget.userDetails['farmer?']){

        if(mailController.text.isEmpty){
          setState(() {
            mailError="Mail can't be empty!";
            mailErrorCondition=true;
          });
          return;
        }
        else if(phoneController.text.isEmpty){
          setState(() {
            phoneError="Can't be empty!";
            phoneErrorCondition=true;
          });
          return;
        }
        else if(DomainControllers[0].text.isEmpty){
          setState(() {
            domainError="can't be empty!";
            domainErrorCondition=true;
          });
          return;
        }
        else if(DescriptionController.text.isEmpty){
          setState(() {
            descriptionError="Description can't be empty!";
            descriptionErrorCondition=true;
          });
          return;
        }
        else if(AddressController1.text.isEmpty){
          setState(() {
            addressError="Address can't be empty!";
            addressErrorCondition=true;
          });
          return;
        }
      //loading animation
      loadAnimation(context);

      List domainVals=[];
      for(var i in DomainControllers){
        if(i.text.isNotEmpty) domainVals.add(i.text);
      }

      await userRef.update({
        "name" : nameController.text,
        "contact_details" : {
          "mail_id" : mailController.text,
          "pno" : phoneController.text
        },
        "about" : DescriptionController.text,
        "address" : AddressController1.text + "\n" + AddressController2.text + "\n" + AddressController3.text,
        "farm_type" : domainVals
      }).catchError((e){
        success=false;
        PopUp(context,'$e', 30, Colors.redAccent, FontWeight.w400, "Continue");
      });
    }
    else{
      //loading animation
      loadAnimation(context);

      await userRef.update({
          "name" : nameController.text
      }).catchError((e){
        success=false;
        PopUp(context,'$e', 30, Colors.redAccent, FontWeight.w400, "Continue");
      });
    }

    if(success){

      nameErrorCondition=false;
      mailErrorCondition=false;
      phoneErrorCondition=false;
      domainErrorCondition=false;
      descriptionErrorCondition=false;
      addressErrorCondition=false;

      //close animation
      Navigator.of(context).pop();
      PopUp(context,'Account Updated!', 30, Colors.green, FontWeight.w400, "Continue");


      setState(() {
        widget.mode="view-mode";
        editable=false;
      });
    }
  }

  modeChangeButton(){

    //view mode, suggest edit button
    if(widget.mode=="view-mode"){
      return TextButton(
          onPressed: (){
            setState(() {
              widget.mode="edit-mode";
              editable=true;
            });
          },
          style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Text(
                  'Edit ',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: darkerGreen
                  ),
                ),
                Icon(
                  Icons.edit_rounded,
                  color: darkerGreen,
                  size: 30,
                )
              ],
            ),
          ),
        );
    }

    //edit button,suggest save
    else{
      return TextButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext){
                return Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: myBackground,
                    ),
                    child: Column(
                      children: [
                        VerticalPadding(paddingSize: 59),
                        DefaultTextStyle(
                            style: GoogleFonts.lato(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            child: const Text(
                              'Confirm Changes?',
                              textAlign: TextAlign.center,
                            )
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            //discard
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.mode="view-mode";
                                  editable=false;
                                  getDetails();
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: darkerGreen),
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w700,
                                        color: myBackground,
                                        fontSize: 25,
                                      ),
                                      child: const Text(
                                        'Discard',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                              ),
                            ),

                            HorizontalPadding(paddingSize: 8),

                            GestureDetector(
                              onTap: () {
                                saveChanges();
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: darkerGreen),
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w700,
                                        color: myBackground,
                                        fontSize: 25,
                                      ),
                                      child: const Text(
                                        'Confirm',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            HorizontalPadding(paddingSize: 8),

                          ],
                        ),
                        VerticalPadding(paddingSize: 8),
                      ],
                    ),
                  ),
                );
              }
          );
          // setState(() {
          //   widget.mode="view-mode";
          // });
        },
        style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Text(
                'Save ',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: darkerGreen
                ),
              ),
              Icon(
                Icons.save_rounded,
                color: darkerGreen,
                size: 30,
              )
            ],
          ),
        ),
      );
    }
  }

  late List<TextEditingController> DomainControllers=[];

  void deleteDomain(int pos){
    print("pressed");
    setState(() {
      if(DomainControllers.length>1) DomainControllers.removeAt(pos);
    });
  }

  void addDomain(){
    TextEditingController newController= TextEditingController();
    setState(() {
      DomainControllers.add(newController);
    });
  }

  farmerDetails(){
    if(widget.userDetails['farmer?']){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //mail id
          CustomTextBox2(controller: mailController, Title: 'Support Mail Id', editable: editable,errorCondition: mailErrorCondition, errorText: mailError),
          //phone no
          CustomTextBox2(controller: phoneController, Title: 'Support Phone No',editable: editable,errorCondition: phoneErrorCondition,  errorText: phoneError),

          //domains
          Text(
            "Domains",
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
              fontSize: 25,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 60),
            child: ListView.builder(
                itemCount: DomainControllers.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context,int index){
                  return ListTile(
                    leading: SizedBox(
                        width: 180,
                        height: 50,
                        child: TextField(
                          onChanged: (String value){
                            setState((){
                              domainErrorCondition=false;
                            });
                          },
                          enabled: editable,
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
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent)
                            ),
                            fillColor: Colors.green.shade50,
                            filled: true,
                            hintStyle: GoogleFonts.lato(
                                color: Colors.black26
                            ),
                            errorText: (domainErrorCondition==true && index==0)? domainError: null,
                            // errorText:
                          ),
                          style: GoogleFonts.lato(
                            color: Colors.green.shade700,
                          ),
                          cursorColor: Colors.teal,
                          showCursor: true,
                        )
                    ),
                    trailing: editable? IconButton(
                      onPressed: (){deleteDomain(index);},
                      icon: Icon(CupertinoIcons.xmark),
                    ) : null,

                  );
                }
            ),
          ),
          if(editable) Row( children: [
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

          VerticalPadding(paddingSize: 8),

          //description
          CustomTextBox2(controller: DescriptionController, Title: 'Description',editable: editable,multiline: true, errorCondition: descriptionErrorCondition, errorText: descriptionError,),

          //address
          Text(
            'Address',
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          VerticalPadding(paddingSize: 5),
          CusTextBoxAlone2(controller: AddressController1,errorCondition: addressErrorCondition, errorText: addressError,editable: editable),
          if(splittedAddress[1]!="" || editable==true)CusTextBoxAlone2(controller: AddressController2,editable: editable),
          if(splittedAddress[2]!=""|| editable==true) CusTextBoxAlone2(controller: AddressController3,editable: editable,),


        ],
      );
    }
  }
  //controllers
  late TextEditingController nameController;
  late TextEditingController mailController;
  late TextEditingController phoneController;
  late List<TextEditingController> domainControllers=[];
  late TextEditingController DescriptionController;
  late TextEditingController AddressController1;
  late TextEditingController AddressController2;
  late TextEditingController AddressController3;

  //error texts
  String? nameError;
  String? mailError;
  String? phoneError;
  String? domainError;
  String? descriptionError;
  String? addressError;

  //error conditions
  bool nameErrorCondition=false;
  bool mailErrorCondition=false;
  bool phoneErrorCondition=false;
  bool domainErrorCondition=false;
  bool descriptionErrorCondition=false;
  bool addressErrorCondition=false;

  var splittedAddress;
  getDetails(){
    nameController=TextEditingController(text: widget.userDetails['name']);
    mailController=TextEditingController(text: widget.userDetails['contact_details']['mail_id']);
    phoneController=TextEditingController(text: widget.userDetails['contact_details']['pno']);
    DomainControllers=[];
    for(var i in widget.userDetails['farm_type']){
      TextEditingController temp = TextEditingController(text: i);
      DomainControllers.add(temp);
    }
    DescriptionController=TextEditingController(text: widget.userDetails['about']);

    final str=widget.userDetails['address'];
    splittedAddress=str.split('\n');
    AddressController1=TextEditingController(text: splittedAddress[0]);
    AddressController2=TextEditingController(text: splittedAddress[1]);
    AddressController3=TextEditingController(text: splittedAddress[2]);
  }

  @override
  void initState(){
    super.initState();
    widget.mode= widget.mode ?? "view-mode";
    editable= (widget.mode=='edit-mode')? true: false;

    getDetails();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalPadding(paddingSize: 30),
            Row(
              children: [
                Text(
                  'Account',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.green
                  ),
                ),
                Spacer(),

                //indicates the current mode button
                modeChangeButton(),
              ],
            ),

            VerticalPadding(paddingSize: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //name
                    CustomTextBox2(controller: nameController, Title: "Name",editable: editable,errorText: nameError, errorCondition: nameErrorCondition, ),
              
                    farmerDetails(),
                    
                  ],
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}

//text box
class CustomTextBox2 extends StatefulWidget {
  CustomTextBox2({
    super.key,
    this.hintText,
    required this.controller,
    this.errorText,
    this.errorCondition,
    this.optionalCondition,
    required this.Title,
    this.helperText,
    this.multiline,
    this.editable
  });
  final String? hintText;
  final String Title;
  final TextEditingController controller;
  final String? errorText;
  final String? helperText;
  bool? errorCondition;
  bool? multiline;
  //for to make the text field editable or not
  bool? editable;
  //made for cases when to remove other TextFields error message
  bool? optionalCondition;



  @override
  State<CustomTextBox2> createState() => _CustomTextBox2();
}

class _CustomTextBox2 extends State<CustomTextBox2> {

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
        Text(
          widget.Title,
          textAlign: TextAlign.left,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        TextField(
          onChanged: (String value){
            setState((){
              widget.errorCondition=false;
              widget.optionalCondition=false;
            });
          },

          enabled: widget.editable?? true,
          controller: widget.controller..text,
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
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
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
      ],
    );
  }
}

class CusTextBoxAlone2 extends StatefulWidget {
  CusTextBoxAlone2 ({
    super.key,
    this.hintText,
    required this.controller,
    this.errorText,
    this.errorCondition,
    this.optionalCondition,
    this.helperText,
    this.multiline,
    required this.editable
  });
  final String? hintText;
  final TextEditingController controller;
  final String? errorText;
  final String? helperText;
  bool? errorCondition;
  bool? multiline;
  bool editable;
  //made for cases when to remove other TextFields error message
  bool? optionalCondition;



  @override
  State<CusTextBoxAlone2> createState() => _cusTextBoxAlone2 ();
}

class _cusTextBoxAlone2 extends State<CusTextBoxAlone2> {

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
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabled: widget.editable,
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
    );
  }
}
