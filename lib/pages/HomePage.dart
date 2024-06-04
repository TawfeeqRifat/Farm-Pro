import 'dart:ui';
import 'package:farm_pro/pages/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:farm_pro/pages/schemesPage.dart';
import 'package:farm_pro/pages/farmersPage.dart';
import 'package:farm_pro/sample_details.dart';
import '../Utilities/CustomWidgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.detail});
  final dynamic detail;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomIndex=0;
  static List<Widget> pages=<Widget>[
    FarmerPage(detail: details, userDetail: details['hitori goto'],),
     SchemesPage(scheme: schemes),
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

  String headlineText='Explore';
  List<String> headlineList=['Explore','Schemes','Tips'];

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
                backgroundImage: NetworkImage('${details['hitori goto']?['profile']}'),
              ),
              const VerticalPadding(paddingSize: 12),
              Text('${details['hitori goto']?['name']}',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
              const VerticalPadding(paddingSize: 20),
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
              IconButton(onPressed: (){
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(context,CupertinoPageRoute(builder: (Builder)=> LoginPage()));
              },
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

      body: Center(
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
      )

    );
  }
}



