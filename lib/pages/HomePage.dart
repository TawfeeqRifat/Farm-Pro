import 'dart:async';
import 'dart:ui';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:farm_pro/global_variable.dart';
import 'package:farm_pro/pages/SignUpForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:farm_pro/pages/schemesPage.dart';
import 'package:farm_pro/pages/farmersPage.dart';
import '../Utilities/CustomWidgets.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  late String username;

  int bottomIndex=0;
  late List<Widget> pages;

  String headlineText='Explore';
  List<String> headlineList=['Explore','Schemes','Tips'];
  final user= FirebaseAuth.instance.currentUser;

  dynamic firebaseDetails;
  final ref = FirebaseDatabase.instance.ref();
  //get started for new users
  Future<bool> _checkUserExists() async {
    firebaseDetails = await ref.child('details').get();
    firebaseDetails = firebaseDetails.value;
    List<dynamic> users = firebaseDetails.keys.toList();
    List<dynamic> userEmails = [];
    for(var i in users) {
      userEmails.add(firebaseDetails[i]['official_mail']);
      if(firebaseDetails[i]['official_mail']==user?.email){
        setState(() {
          userId= i;
          userProfile= firebaseDetails[userId]['profile'];
        });
        return true;
      }
    }
    return false;
    // return userEmails.contains(user?.email);

  }

  Future<void> _createAccountPopUp() async {
    if(await _checkUserExists()==false){
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
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, CupertinoPageRoute(
                            builder: (context)=> SignUpForm()));

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


                  ],
                ),
              ),
            );
          });
    }

    
  }


  void signOut(){
   debugPrint('signed out');
    FirebaseAuth.instance.signOut();

  }

  @override
 void initState(){
    super.initState();

    FirebaseDatabase.instance.setPersistenceEnabled(true);

    pages=<Widget>[
      // FarmerPage(
      //     farmerDetails: widget.detail,
      //     userDetail: widget.detail['hitori goto']),
      FarmerPage2(),
      SchemesPage(),
      Center(
        child: Column(
          children: [
            const VerticalPadding(paddingSize: 100),
            Text('Coming Soon!', textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  fontSize: 50
              ),)
          ],
        ),
      )
    ];

    _createAccountPopUp();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFf5fff7),

      bottomNavigationBar: NavigationBar(
          height: 64,
          backgroundColor: const Color(0xFFE1F1E4),
          onDestinationSelected: (int index){
            setState(() {
              bottomIndex=index;
              headlineText=headlineList[index];
            });
          },
          indicatorColor: const Color(0xFF95C19E),
          selectedIndex: bottomIndex,
          destinations: const<Widget>[
            NavigationDestination(
                selectedIcon: Icon(Icons.agriculture_outlined, color: Colors.white,),
                icon: Icon(Icons.agriculture_outlined),
                label: 'Farmers'),
            NavigationDestination(
                selectedIcon: Icon(Icons.handshake_outlined, color: Colors.white,),
                icon: Icon(Icons.handshake_outlined,),
                label: 'Schemes'),
            NavigationDestination(
                selectedIcon: Icon(Icons.handshake_outlined, color: Colors.white),
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
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    // (userId!=null)? firebaseDetails[userId]['profile'] :
                    userProfile ??
                    user?.photoURL ?? 'https://static.vecteezy.com/system/resources/thumbnails/036/280/651/small/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg'),
                backgroundColor: myGreen,
                foregroundColor: myGreen,

              ),
              const VerticalPadding(paddingSize: 12),
              Text(
                (userId!=null)? firebaseDetails[userId]['name']:
                    user?.displayName?? 'User',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
              const VerticalPadding(paddingSize: 20),
              GestureDetector(
                onTap: ()  {
                  if(_createAccountPopUp()==false){
                    print('doesnt');
                  }
                  else{
                    print("accoutn exist'");
                  }
                },
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    height: 65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffe1f1e4),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                        child: Text('ACCOUNT',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 22,
                          ),
                        )
                    ),
                  ),
                ),
              ),
              const VerticalPadding(paddingSize: 5),
              GestureDetector(
                onTap: (){},
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    height: 65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffe1f1e4),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                        child: Text('SHOP',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 22,
                          ),
                        )
                    ),
                  ),
                ),
              ),

              const Spacer(),
              IconButton(onPressed: signOut,
                  icon: const Icon(Icons.logout_outlined,
                    size: 30,
                    color: Colors.black54,
                  ),
              ),
              const VerticalPadding(paddingSize: 5),
              Text('LOGOUT',
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const VerticalPadding(paddingSize: 50)

            ],
          ),
        )
      ),

      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: [

              const VerticalPadding(paddingSize: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(padding: const EdgeInsetsDirectional.only(start: 18),
                    child: Text(headlineText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(padding: const EdgeInsetsDirectional.only(end: 8),
                    child: Builder(
                      builder: (context){
                        return IconButton(
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            icon: const Icon(Icons.account_circle,
                              size: 28,
                            )
                        );
                      },
                    )
                  )
                ],
              ),
              const VerticalPadding(paddingSize: 8),
        
              pages.elementAt(bottomIndex),
            ],
        
        
          ),
        ),
      )

    );
  }
}



