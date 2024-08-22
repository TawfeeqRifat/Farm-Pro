import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customFunction.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {


  void callPop() async {
    await Future.delayed(Duration(microseconds: 1));
    PopUp(context, "Coming Soon!", 30, Colors.black, FontWeight.w400,"Okay");
  }
  @override
  void initState(){
    super.initState();

    //coming soon pop up
    callPop();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [

        ],
      );
  }
}
