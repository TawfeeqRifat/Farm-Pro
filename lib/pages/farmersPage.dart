import 'dart:async';
import 'dart:ui';

import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/services/FireStore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:farm_pro/pages/detailsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

// class FarmerPage extends StatefulWidget {
//   const FarmerPage({super.key,required this.farmerDetails, required this.userDetail});
//   final dynamic farmerDetails;
//   final dynamic userDetail;
//   @override
//   State<FarmerPage> createState() => _FarmerPageState();
// }
//
// class _FarmerPageState extends State<FarmerPage> {
//
//   dynamic _firebaseDetails;
//   final ref = FirebaseDatabase.instance.ref();
//   void _getDetails() async {
//     final snapshot = await ref.child('details').get();
//     if (snapshot.exists) {
//       _firebaseDetails=snapshot.value;
//       List<Object?> names = _firebaseDetails.keys.toList();
//       print(names);
//
//     } else {
//       print('No data available.');
//     }
//     print(_firebaseDetails);
//   }
//
//   final searchController = TextEditingController();
//
//   String query='';
//   late List<String> searchResults;
//
//   void onQueryChanged(String query){
//     setState(() {
//       if(query==''){
//         searchResults= widget.farmerDetails.keys.toList();
//       }
//       else{
//         searchResults.clear();
//         for (var i in widget.farmerDetails.keys) {
//           if (i.toLowerCase().contains(query.toLowerCase())) {
//             searchResults.add(i);
//           }
//         }
//       }
//
//       debugPrint(query);
//       for(var i in searchResults){
//         debugPrint(i);
//       }
//     });
//   }
//
//   void textClearance(){
//     setState(() {
//
//
//     });
//   }
//   Widget displayFarmPageCards(){
//     return Column(
//         children:[
//           for(var i in searchResults)
//             FarmerPageCard(detail: widget.farmerDetails['$i'],userDetail: widget.userDetail,details2: _firebaseDetails,),
//
//         ]
//     );
//   }
//
//
//
//   @override
//   void initState(){
//     super.initState();
//     searchResults=widget.farmerDetails.keys.toList();
//     // searchResults=_firebaseDetails.keys.toList();
//     _getDetails();
//   }
//   @override
//   void dispose(){
//     searchController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//
//           //search box
//           Padding(padding: const EdgeInsets.symmetric(horizontal: 9),
//             child: Container(
//                height: 60,
//             child: TextField(
//               onChanged: onQueryChanged,
//               controller: searchController,
//               style: GoogleFonts.lato(),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: const Color(0xffe1f1e4),
//                 border: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                     color: Colors.transparent,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:  const BorderSide(
//                     color: Colors.transparent,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                     color: Colors.transparent,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//
//                 hintText: 'Search',
//                 prefixIcon: const Icon(Icons.search_outlined, color: Colors.black,),
//                 suffixIcon: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 100),
//                   transitionBuilder: (child, opacity) =>
//                       FadeTransition(opacity: opacity, child: child),
//                   child: searchController.text.isNotEmpty
//                       ? Material(
//                     key: const ValueKey(true),
//                     color: Colors.transparent,
//                     shape: const CircleBorder(),
//                     clipBehavior: Clip.hardEdge,
//                     child: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           searchController.text='';
//                           searchResults= widget.farmerDetails.keys.toList();
//                           FocusScope.of(context).unfocus();
//
//                         });
//                       },
//
//                       icon: const Icon(Icons.clear,color: Colors.black,),
//                     ),
//                   )
//                       : const SizedBox.shrink(key: ValueKey(false)),
//                 ),
//
//
//               ),
//               textAlign: TextAlign.left,
//             ),
//             )),
//           const VerticalPadding(paddingSize: 6),
//           SizedBox(
//             height: 622.72,
//             child: SingleChildScrollView(
//                 child: Container(
//                   width: 500,
//                   color: const Color(0xFFF5FFF7),
//                   child: Column(
//                     children: [
//                       displayFarmPageCards(),
//                     ],
//                   ),
//
//                 )
//             ),
//           ),
//         ],
//       ),
//
//     );
//
//   }
//
// }

class FarmerPageCard extends StatefulWidget {
  const FarmerPageCard({super.key, required this.detail, required this.userDetail});
  final dynamic detail;
  final dynamic userDetail;
  @override
  State<FarmerPageCard> createState() => _FarmerPageCardState();
}

class _FarmerPageCardState extends State<FarmerPageCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(

            onTap: (){
              Navigator.push(context, CupertinoPageRoute(
              //fullscreenDialog: true  ,
              builder: (context)=> DetailsPage(detail: widget.detail, userDetail: widget.userDetail,)));
            },

            child: Container(

              decoration: BoxDecoration(
                color: const Color(0xffe1f1e4),
                borderRadius: BorderRadius.circular(7),

              ),
              width: 370,
              child: Column(
                children: [
                  const VerticalPadding(paddingSize: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const HorizontalPadding(paddingSize: 5),
                      SizedBox(
                        height: 76,
                        width: 76,

                        child: GestureDetector(
                          onTap: (){
                            showDialog(context: context,
                                barrierDismissible: false,
                                builder: (Builder){
                                return InteractiveViewer(
                                  constrained: true,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.detail['profile'],
                                        imageBuilder: (context,imageProvider){
                                          return Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                              ),
                                            ),
                                          );
                                        },
                                        errorWidget: (context,url,error)=>const  Icon(Icons.person_sharp,size: 60,),
                                        placeholder: (context,url){
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
                                      )
                                  ),
                              );
                            });
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: widget.detail['profile'],
                                imageBuilder: (context,imageProvider){
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );

                                },
                                errorWidget: (context,url,error)=>const  Icon(Icons.person_sharp,size: 60,),
                                placeholder: (context,url){
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



                              )

                          ),
                        ),
                      ),
                      const HorizontalPadding(paddingSize: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(widget.detail['name'],style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          )),
                          //const VerticalPadding(paddingSize: 5),
                          SizedBox(
                            height: 40,
                            width: 264,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:[
                                  for(var i in widget.detail['farm_type'])
                                    FarmTypeFloat(typeName: i),
                                ],
                              ),),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 1) ),
                          Stack(
                            alignment: Alignment.topLeft,
                            children: [

                              Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB5DADC),
                                  borderRadius: BorderRadius.circular(12),

                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const HorizontalPadding(paddingSize: 15),
                                    Text(widget.detail['contact_details']['pno'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                     )),
                                   const HorizontalPadding(paddingSize: 4)
                                  ],
                                )

                              ),
                              Positioned(
                                left:-12,
                                top: -12,
                                child: IconButton(onPressed: ()async{
                                String p=widget.detail['contact_details']['pno'];
                                Uri phone=Uri.parse('tel:$p');
                                if(await launchUrl((phone))){
                                  debugPrint("can dial");
                                }
                                else{
                                  debugPrint('cannot dial');
                                }
                              },
                                icon: const CircleAvatar(
                                  backgroundColor: Color(0xFF95C19E),
                                  radius: 12,
                                  child: Icon(Icons.phone,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),)
                            ],
                          )
                        ],
                      ),

                    ],
                  ),

                  const VerticalPadding(paddingSize: 5),
                ],
              ),

            )
        ),
        const VerticalPadding(paddingSize: 10),
      ],
    );
  }
}

class FarmTypeFloat extends StatelessWidget {
  const FarmTypeFloat({super.key,required this.typeName,this.myheight, this.myFontSize,this.myColor});
  final String typeName;
  final double? myheight;
  final double? myFontSize;
  final Color? myColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: myheight??23,
          decoration: BoxDecoration(
            color: const Color(0xFF95C19E),
            borderRadius: BorderRadius.circular(5),
          ),
          child:  Row(
            children: [
             const HorizontalPadding(paddingSize: 3),
              Text('$typeName',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: myColor?? Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: myFontSize?? 12,
                    ),
                  )),
              const HorizontalPadding(paddingSize: 3),
            ],
          ),

        ),
        const HorizontalPadding(paddingSize: 4),
      ],
    );
  }
}


class FarmerPage2 extends StatefulWidget {
  const FarmerPage2({super.key});

  @override
  State<FarmerPage2> createState() => _FarmerPage2State();
}

class _FarmerPage2State extends State<FarmerPage2> {

  //reading farmers data from firebase

  dynamic _firebaseDetails;
  final ref = FirebaseDatabase.instance.ref();

  late StreamSubscription _detailsStream;
  void _getDetails() async {
    //active fetching
    _detailsStream=ref.child('details').onValue.listen((event){
      final Object? descritpion=event.snapshot.value;
      // print(descritpion);
      setState(() {
        _firebaseDetails=event.snapshot.value;
        _allUsers=_firebaseDetails.keys.toList();
        searchResults=_allUsers.where((e)=>_firebaseDetails[e]['farmer?']==true).toList();

      });
    });
  }

  final searchController = TextEditingController();

  String query='';
  List<dynamic> searchResults=[];
  late List<dynamic> _allUsers;

  void onQueryChanged(String query){
    setState(() {
      if(query==''){
        searchResults= _firebaseDetails.keys.toList();
      }
      else{
        searchResults.clear();
        for (var i in _firebaseDetails.keys) {
          if (i.toLowerCase().contains(query.toLowerCase()) && _firebaseDetails[i]['farmer?']) {
            searchResults.add(i);
          }
        }
      }

      debugPrint(query);
      for(var i in searchResults){
        // debugPrint(i);
      }
    });
  }

  void textClearance(){
    setState(() {


    });
  }
  Widget displayFarmPageCards(){
    return Column(
        children:[
          for(var i in searchResults)
            FarmerPageCard(detail: _firebaseDetails[i],userDetail: _firebaseDetails['hitori goto']),

        ]
    );
  }



  @override
  void initState(){
    super.initState();


    _getDetails();
  }

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }

  @override
  void deactivate(){
    super.deactivate();
    _detailsStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          //search box
          Padding(padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Container(
                height: 60,
                child: TextField(

                  onChanged: onQueryChanged,
                  controller: searchController,
                  style: GoogleFonts.lato(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffe1f1e4),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:  const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search_outlined, color: Colors.black,),
                    suffixIcon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      transitionBuilder: (child, opacity) =>
                          FadeTransition(opacity: opacity, child: child),
                      child: searchController.text.isNotEmpty
                          ? Material(
                        key: const ValueKey(true),
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              searchController.text='';
                              searchResults= _firebaseDetails.keys.toList();
                              FocusScope.of(context).unfocus();

                            });
                          },

                          icon: const Icon(Icons.clear,color: Colors.black,),
                        ),
                      )
                          : const SizedBox.shrink(key: ValueKey(false)),
                    ),


                  ),
                  textAlign: TextAlign.left,
                  cursorColor: Colors.teal,
                ),
              )),
          const VerticalPadding(paddingSize: 6),
          SizedBox(
            height: 622.72,
            child: SingleChildScrollView(
                child: Container(
                  width: 500,
                  color: const Color(0xFFF5FFF7),
                  child: Column(
                    children: [
                      displayFarmPageCards(),
                    ],
                  ),

                )
            ),
          ),
        ],
      ),

    );
  }
}
