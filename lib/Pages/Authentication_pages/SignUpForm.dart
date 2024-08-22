
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:crop_image/crop_image.dart';

import 'package:farm_pro/Utilities/custom.dart';
import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/pages/HomePage.dart';

import '../../customFunction.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final nameController = TextEditingController();
  final idController = TextEditingController();


  //Image cropping
  var croppedImage;
  final imageController= CropController(
    aspectRatio: 1,
    defaultCrop: Rect.fromLTRB(0.1, 0.1, 0.9, 0.9)
  );
  void Cropper(){
    showDialog(context: context, builder: (BuildContext){
      return Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 150),
                    child: CropImage(
                      controller: imageController,
                      image: Image.file(File(_selectedFilePath!)),
                    ),
                  ),
                ),
              ),

              Positioned(
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                              child: DefaultTextStyle(
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white54,
                                ),
                                child: Text('Cancel'),
                              )
                          ),
                        ),
                        Spacer(),

                        //rotate
                        IconButton(
                            onPressed: imageController.rotateLeft,
                            icon: Icon(Icons.rotate_90_degrees_ccw,color: Colors.white54,size: 25,)
                        ),
                        Spacer(),

                        //done
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: GestureDetector(
                              onTap: () async {
                                final img= await imageController.croppedImage();

                                //storing in local storage to get path
                                var bitmap = await imageController.croppedBitmap();
                                var data=await bitmap.toByteData(format: ImageByteFormat.png);
                                var bytes = data!.buffer.asUint8List();
                                await File(_selectedFilePath!).writeAsBytes(bytes);

                                setState(() {
                                  croppedImage= img;
                                });
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                              },
                              child: DefaultTextStyle(
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white54,
                                ),
                                child: Text('Done '),
                              )
                          ),
                        ),
                      ],
                    ),
                    VerticalPadding(paddingSize: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  //Imagepicker for image
  String? _selectedFilePath;
  XFile? profile;

  void _pickProfile()async{
    showCupertinoModalBottomSheet(
      expand: false,
      
      context: context,
      builder: (context) => Container(
        height: 250,
        // width: ,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 150),
              child: CustomDivider(color: Colors.green,thickness: 5,)
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: Row(
                children: [
                  DefaultTextStyle(
                      style: GoogleFonts.lato(
                          color: Colors.green,
                          fontSize: 30,
                          fontWeight: FontWeight.w700
                      ),
                      child: Text('Profile Photo')
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: (){
                        setState(() {
                          _selectedFilePath=null;
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(CupertinoIcons.trash,color: Colors.green,))
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //camera
                  GestureDetector(
                    onTap: (){
                      getImage(2);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          CircleAvatar(backgroundColor: myGreen,foregroundColor: myGreen,radius: 30,child: Icon(CupertinoIcons.camera,color: Colors.green, size: 40,)),
                          VerticalPadding(paddingSize: 5),
                          DefaultTextStyle(
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                              ),
                              child: Text('Camera')
                          ),
                        ],
                      ),
                    ),
                  ),

                  //gallery
                  GestureDetector(
                    onTap: (){
                      getImage(1);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          CircleAvatar(backgroundColor: myGreen,foregroundColor: myGreen,radius: 30,child: Icon(Icons.photo_camera_back,color: Colors.green, size: 40,)),
                          VerticalPadding(paddingSize: 5),
                          DefaultTextStyle(
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                              ),
                              child: Text('Gallery')
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),

      ),
    );


  }


  Future<void> getImage(int i) async {
    final profile;

    //galley
    if(i==1){
      profile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(profile!=null) {
        setState(() {
          _selectedFilePath = profile?.path ?? _selectedFilePath;
        });
        Cropper();
      }
      else{
        //if user cancel, permission denied
        Navigator.of(context).pop();
      }
    }

    //camera
    else if(i==2){
      profile = await ImagePicker().pickImage(source: ImageSource.camera);
      if(profile!=null) {
        setState(() {
          _selectedFilePath = profile?.path ?? _selectedFilePath;
        });
        Cropper();
      }
      else{
        //if user cancel, permission denied
        Navigator.of(context).pop();
      }
    }
  }

  //image showing widget
  Widget showProfile(){
    if(_selectedFilePath!=null){
      return
          Container(
            height: 95,
            width: 95,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(55),
              // child: Image.file(
              //   File(_selectedFilePath!),
              //   fit: BoxFit.cover,
              // ),
              child: croppedImage,
            ),
          );
    }
    else{
      return Icon(CupertinoIcons.person_crop_circle,size: 110, color: darkerGreen,);
    }
  }

  //setting up cloud storage for profile
  final _storage = FirebaseStorage.instance;
  var profilesRef;
  late UploadTask uploadTask;
  String? urlDownload;

  Future<void> _uploadProfile() async {

    //creating ref to the storage
    final path='UserData/profile/${idController.text}';
    var ref=FirebaseStorage.instance.ref().child(path);

    //removing previous
    try {
      await ref.delete();
    }on FirebaseException catch (e) {
      print('Profile doesn\'t already exist');
    }
    //check if image has been given
    if(_selectedFilePath!=null){
      final file= File(_selectedFilePath!);
      uploadTask = ref.putFile(file);
      final snapshot= await uploadTask!.whenComplete((){});
      urlDownload=await snapshot.ref.getDownloadURL();
    }
  }


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

      //loading
      loadAnimation(context);

      await _uploadProfile();
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
          "profile" : urlDownload ?? user?.photoURL ?? null
        }
      }).catchError((error){

        //close loading
        Navigator.pop(context);

        print("error: $error");
        success=false;
        PopUp(context,'$error!', 30, Colors.redAccent, FontWeight.w400, "Continue");
      });
      if(success){

        //close loading
        Navigator.pop(context);

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
                        style: GoogleFonts.lato(
                          fontSize: 38,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        child: const Text(
                          'Your Account \nhas been set!',
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const VerticalPadding(paddingSize: 20),

                      GestureDetector(
                        onTap: (){
                          // Navigator.popAndPushNamed(context, '/homepage');
                          Navigator.popUntil(context, ModalRoute.withName('/homepage'));
                          Navigator.push(context, CupertinoPageRoute(builder:(context) => HomePage(),));
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
                              child: const Text(
                                'Continue',
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
    }
  }

  @override
  void initState(){
    super.initState();

    //assigning a name for ease of use
    nameController.text = user?.displayName ?? ' ';

    //connect firebase for write
    _detailsRef = FirebaseDatabase.instance.ref('details');

    //connect firebase for constant read
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
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            const VerticalPadding(paddingSize: 40),

            //title
            Text(
              'Finish Setting Up',
              style: GoogleFonts.signikaNegative(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
            ),
            const VerticalPadding(paddingSize: 40),

            //profile
            GestureDetector(
              onTap: (){
                  _pickProfile();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(width: 140,),
                  Positioned(child: CircleAvatar(backgroundColor: myGreen,radius: 55,)),
                  showProfile(),
                  Positioned(
                    bottom: 3,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: myGreen
                      ),
                      child: Icon(
                        CupertinoIcons.camera_circle_fill,
                        color: darkerGreen,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              )
            ),

            const VerticalPadding(paddingSize: 25),

            //name
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
            const VerticalPadding(paddingSize: 45),
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
  bool? multiline;
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


