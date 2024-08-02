import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_image/crop_image.dart';
import 'package:farm_pro/Pages/Authentication_pages/FarmerForm.dart';
import 'package:farm_pro/Pages/Profile_pages/Account_page.dart';
import 'package:farm_pro/Pages/Profile_pages/Shop_page.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:farm_pro/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:farm_pro/pages/Schemes_pages/schemesPage.dart';
import 'package:farm_pro/pages/Farmers_pages/farmersPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../Utilities/CustomWidgets.dart';
import 'Authentication_pages/SignUpForm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String username;

  int bottomIndex = 0;
  late List<Widget> pages;

  String headlineText = 'Explore';
  List<String> headlineList = ['Explore', 'Schemes', 'Tips'];
  final user = FirebaseAuth.instance.currentUser;

  dynamic firebaseDetails;
  final ref = FirebaseDatabase.instance.ref();

  //get started for new users
  //fwd bool indicated whether or not to push to accounts page
  //true-push account page
  Future<void> _checkUserExists(bool fwd) async {
    firebaseDetails = await ref.child('details').get();
    firebaseDetails = firebaseDetails.value;
    List<dynamic> users = firebaseDetails.keys.toList();
    List<dynamic> userEmails = [];
    for (var i in users) {
      userEmails.add(firebaseDetails[i]['official_mail']);
      if (firebaseDetails[i]['official_mail'] == user?.email) {
        setState(() {
          userId = i;
          userProfile = firebaseDetails[userId]['profile'];
        });

        //call the accounts page
        if(fwd==true )Navigator.push(context, CupertinoPageRoute(builder: (BuildContext)=> const AccountPage()));
        return;
      }
    }
    return _createAccountPopUp();
  }

  Future<void> _createAccountPopUp() async {
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
                      child: Text(
                        'Finish Setting Up?',
                        style: GoogleFonts.lato(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                        child: Text(
                          'Continue',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            color: myBackground,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
  }

  //check if farmer
  Future<void> _checkIfFarmer() async {
    if(userId!=null){
      var FarmerUser;
      FarmerUser = await ref.child("details/$userId").get();
      FarmerUser = FarmerUser.value;
      if(FarmerUser['farmer?']==false){
        _createFarmerPopUp();
      }
      else{
        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext)=> const ShopPage()));
        //call shop
      }
      print('user exists $userId');
    }
    else{
      _checkUserExists(false);
    }
  }

  Future<bool?> _createFarmerPopUp() async {
    return showDialog
        (context: context,
          builder: (BuildContext context){
            return Center(
              child: Container(
                height: 450,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: myBackground
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalPadding(paddingSize: 5),
                    Spacer(),
                    Center(
                      child: DefaultTextStyle(
                        style: GoogleFonts.lato(
                          fontSize: 40,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        child: const Text(
                          'JOIN US AS A FARMER?',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DefaultTextStyle(
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          child: const Text(
                            'Join Farm Pro to list your products on your profile and connect with customers directly.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, CupertinoPageRoute(
                            builder: (context)=> const Farmerform()));

                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: darkerGreen
                        ),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            color: myBackground,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const VerticalPadding(paddingSize: 5),
                  ],
                ),
              ),
            );
          });
  }

  void signOut() {
    debugPrint('signed out');
    FirebaseAuth.instance.signOut();
  }

  Widget showProfile() {
    if (userProfile == null) {
      return Icon(
        CupertinoIcons.person_crop_circle,
        size: 110,
        color: darkerGreen,
      );
    } else {
      return Container(
        height: 100,
        width: 100,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: userProfile!,
              errorWidget: (context, url, error) => const Icon(
                Icons.person_sharp,
                size: 60,
              ),
              placeholder: (context, url) {
                return const SizedBox(
                  height: 10,
                  width: 10,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      strokeWidth: BorderSide.strokeAlignOutside,
                    ),
                  ),
                );
              },
            )),
      );
    }
  }

  //Image cropping
  var croppedImage;
  final imageController = CropController(
      aspectRatio: 1, defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9));
  void _cropper() {
    showDialog(
        context: context,
        builder: (BuildContext) {
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 150),
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
                                  onTap: () {
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
                                  )),
                            ),
                            const Spacer(),

                            //rotate
                            IconButton(
                                onPressed: imageController.rotateLeft,
                                icon: const Icon(
                                  Icons.rotate_90_degrees_ccw,
                                  color: Colors.white54,
                                  size: 25,
                                )),
                            const Spacer(),

                            //done
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: GestureDetector(
                                  onTap: () async {
                                    final img =
                                        await imageController.croppedImage();

                                    //storing in local storage to get path
                                    var bitmap =
                                        await imageController.croppedBitmap();
                                    var data = await bitmap.toByteData(
                                        format: ImageByteFormat.png);
                                    var bytes = data!.buffer.asUint8List();
                                    await File(_selectedFilePath!)
                                        .writeAsBytes(bytes);

                                    setState(() {
                                      croppedImage = img;
                                    });
                                    _uploadProfile();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: DefaultTextStyle(
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white54,
                                    ),
                                    child: const Text('Done '),
                                  )),
                            ),
                          ],
                        ),
                        const VerticalPadding(paddingSize: 20),
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

  void _pickProfile() async {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      builder: (context) => Container(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
                child: CustomDivider(
                  color: Colors.green,
                  thickness: 5,
                )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  children: [
                    DefaultTextStyle(
                        style: GoogleFonts.lato(
                            color: Colors.green,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                        child: const Text('Profile Photo')),
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            _selectedFilePath = null;
                            userProfile = null;
                          });
                          await _uploadProfile();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          CupertinoIcons.trash,
                          color: Colors.green,
                        ))
                  ],
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //camera
                  GestureDetector(
                    onTap: () {
                      getImage(2);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: myGreen,
                              foregroundColor: myGreen,
                              radius: 30,
                              child: const Icon(
                                CupertinoIcons.camera,
                                color: Colors.green,
                                size: 40,
                              )),
                          const VerticalPadding(paddingSize: 5),
                          DefaultTextStyle(
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                              child: const Text('Camera')),
                        ],
                      ),
                    ),
                  ),

                  //gallery
                  GestureDetector(
                    onTap: () {
                      getImage(1);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: myGreen,
                              foregroundColor: myGreen,
                              radius: 30,
                              child: const Icon(
                                Icons.photo_camera_back,
                                color: Colors.green,
                                size: 40,
                              )),
                          const VerticalPadding(paddingSize: 5),
                          DefaultTextStyle(
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                              child: const Text('Gallery')),
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
    if (i == 1) {
      profile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (profile != null) {
        setState(() {
          _selectedFilePath = profile?.path ?? _selectedFilePath;
        });
        _cropper();
      } else {
        //if user cancel, permission denied
        Navigator.of(context).pop();
      }
    }

    //camera
    else if (i == 2) {
      profile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (profile != null) {
        setState(() {
          _selectedFilePath = profile?.path ?? _selectedFilePath;
        });
        _cropper();
      } else {
        //if user cancel, permission denied
        Navigator.of(context).pop();
      }
    }
  }

  //setting up cloud storage for profile
  final _storage = FirebaseStorage.instance;
  var profilesRef;
  late UploadTask uploadTask;
  String? urlDownload;

  Future<void> _uploadProfile() async {
    //creating ref to the storage
    final path = 'UserData/profile/$userId';
    var ref = FirebaseStorage.instance.ref().child(path);

    //removing previous
    try {
      await ref.delete();
    } on FirebaseException catch (e) {
      debugPrint('Profile doesn\'t already exist $e');
    }

    //get firebase link to write
    final _detailsRef = FirebaseDatabase.instance.ref("details/$userId");

    //check if image has been given
    if (_selectedFilePath != null) {
      final file = File(_selectedFilePath!);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      urlDownload = await snapshot.ref.getDownloadURL();
      //writing in firebase
      _detailsRef.update({"profile": urlDownload});
      setState(() {
        userProfile = urlDownload;
      });
    }
    //image removed
    else {
      //writing in firebase
      _detailsRef.update({"profile": null});
      setState(() {
        userProfile = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.setPersistenceEnabled(true);

    pages = <Widget>[
      const FarmerPage2(),
      SchemesPage(),
      Center(
        child: Column(
          children: [
            const VerticalPadding(paddingSize: 100),
            Text(
              'Coming Soon!',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 50),
            )
          ],
        ),
      )
    ];

    _checkUserExists(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFf5fff7),
        bottomNavigationBar: NavigationBar(
          height: 64,
          backgroundColor: const Color(0xFFE1F1E4),
          onDestinationSelected: (int index) {
            setState(() {
              bottomIndex = index;
              headlineText = headlineList[index];
            });
          },
          indicatorColor: const Color(0xFF95C19E),
          selectedIndex: bottomIndex,
          destinations: const <Widget>[
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.agriculture_outlined,
                  color: Colors.white,
                ),
                icon: Icon(Icons.agriculture_outlined),
                label: 'Farmers'),
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.handshake_outlined,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.handshake_outlined,
                ),
                label: 'Schemes'),
            NavigationDestination(
                selectedIcon:
                    Icon(Icons.handshake_outlined, color: Colors.white),
                icon: Icon(Icons.lightbulb_outlined),
                label: 'Tips')
          ],
          elevation: 15,
        ),
        endDrawer: Drawer(
            child: ColoredBox(
          color: const Color(0xFFf5fff7),
          child: Column(
            children: [
              const VerticalPadding(paddingSize: 40),

              //profile
              GestureDetector(
                  onTap: () {
                    if(userId==null) _checkUserExists(false);
                    else _pickProfile();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 140,
                      ),
                      Positioned(
                          child: CircleAvatar(
                        backgroundColor: myGreen,
                        radius: 55,
                      )),
                      showProfile(),
                      Positioned(
                        bottom: 3,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: myGreen),
                          child: Icon(
                            CupertinoIcons.camera_circle_fill,
                            color: darkerGreen,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  )),
              const VerticalPadding(paddingSize: 20),
              Text(
                (userId != null)
                    ? firebaseDetails[userId]['name']
                    : user?.displayName ?? 'User',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
              const VerticalPadding(paddingSize: 20),

              //account
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextButton(
                  onPressed: () {
                    _checkUserExists(true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                        child: Text(
                      'ACCOUNT',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 22,
                      ),
                    )),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: CustomDivider(
                  color: Colors.green,
                ),
              ),

              //SHOP
              const VerticalPadding(paddingSize: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextButton(
                    onPressed: () {

                        _checkIfFarmer();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Center(
                              child: Text(
                            'SHOP',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 22,
                            ),
                          )),
                        ),
                      ],
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: CustomDivider(
                  color: Colors.green,
                ),
              ),

              const Spacer(),
              IconButton(
                onPressed: signOut,
                icon: const Icon(
                  Icons.logout_outlined,
                  size: 30,
                  color: Colors.black54,
                ),
              ),
              const VerticalPadding(paddingSize: 5),
              Text(
                'LOGOUT',
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const VerticalPadding(paddingSize: 50)
            ],
          ),
        )),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                const VerticalPadding(paddingSize: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 18),
                      child: Text(
                        headlineText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: Builder(
                          builder: (context) {
                            return IconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Scaffold.of(context).openEndDrawer();
                                },
                                icon: const Icon(
                                  Icons.account_circle,
                                  size: 28,
                                ));
                          },
                        ))
                  ],
                ),
                const VerticalPadding(paddingSize: 8),
                pages.elementAt(bottomIndex),
              ],
            ),
          ),
        ));
  }
}

