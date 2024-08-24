import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_pro/Pages/Farmers_pages/detailsAdvanced.dart';
import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:farm_pro/customFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../global_variable.dart';
import '../../Pages/HomePage.dart';
import '../Authentication_pages/SignUpForm.dart';



class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.farmerDetail,required this.details, required this.ref});
  final dynamic farmerDetail;
  final dynamic details;
  final ref;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  @override
  Widget build(BuildContext context) {


    List<AgrItemCard> items=[
      const AgrItemCard(itemName: 'Onion',itemLink: 'https://cdn.pixabay.com/photo/2020/05/18/15/54/onion-5187140_640.jpg',itemStatus: 1),
      const AgrItemCard(itemName: 'Beans',itemLink: 'https://seed2plant.in/cdn/shop/products/Beansseeds.jpg?v=1603967248',itemStatus: 2,),
      const AgrItemCard(itemName: 'Tomato',itemLink: 'https://images.pexels.com/photos/533280/pexels-photo-533280.jpeg?cs=srgb&dl=pexels-pixabay-533280.jpg&fm=jpg',itemStatus: 3,),
      const AgrItemCard(itemName: 'Beans',itemLink: 'https://seed2plant.in/cdn/shop/products/Beansseeds.jpg?v=1603967248',itemStatus: 1,),
      const AgrItemCard(itemName: 'Onion',itemLink: 'https://cdn.pixabay.com/photo/2020/05/18/15/54/onion-5187140_640.jpg',itemStatus: 2),
      const AgrItemCard(itemName: 'Beans',itemLink: 'https://seed2plant.in/cdn/shop/products/Beansseeds.jpg?v=1603967248',itemStatus: 3,),
      const AgrItemCard(itemName: 'Tomato',itemLink: 'https://images.pexels.com/photos/533280/pexels-photo-533280.jpeg?cs=srgb&dl=pexels-pixabay-533280.jpg&fm=jpg',itemStatus: 1,),
      const AgrItemCard(itemName: 'Beans',itemLink: 'https://seed2plant.in/cdn/shop/products/Beansseeds.jpg?v=1603967248',itemStatus: 2,),
    ];
    items.sort((a,b)=>a.itemStatus.compareTo(b.itemStatus));
    String farmerRating;
    if(widget.farmerDetail['rating']['rate']<1.0){
      farmerRating='---';
    }
    else{
      farmerRating=widget.farmerDetail['rating']['rate'].toStringAsFixed(2);
    }

    bool checkIfUser(){
     if(userId!=null) return true;
     else return false;
    }



    return Scaffold(
      body: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 300,
                  child:  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context)=>DetailsAdvanced(farmerDetails: widget.farmerDetail)));
                        },
                        child: Container(
                          height: 250,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF95C19E),
                                ],
                                transform: GradientRotation(6)
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: '',
                            errorWidget: (context,url,error)=> Container(),
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.dstIn,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 130,
                          left: 15,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, CupertinoPageRoute(builder: (BuildContext)=>DetailsAdvanced(farmerDetails: widget.farmerDetail)));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textDirection: TextDirection.ltr,
                              children: [
                                Text('Farmer',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                                Text(widget.farmerDetail['name'],
                                  style: GoogleFonts.lato(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),),
                              ],
                            ),
                          )
                      ),

                      Positioned(
                          top: 190,
                          left: 5,
                          child: Row(
                            children: [

                              //phone
                              IconButton(onPressed: ()async{
                                String p=widget.farmerDetail['contact_details']['pno'];
                                Uri phone=Uri.parse('tel:$p');
                                if(await launchUrl((phone))){
                                  debugPrint("can dial");
                                }
                                else{
                                  debugPrint('cannot dial');
                                }
                              }, icon: Icon(Icons.phone)),

                              //mail
                              IconButton(onPressed: ()async{
                                String mail=widget.farmerDetail['contact_details']['mail_id'];
                                Uri email=Uri.parse('mailto:$mail');
                                await launchUrl(email);
                              }, icon: Icon(Icons.mail_outline)),
                              const HorizontalPadding(paddingSize: 4),

                              //rating
                              const Icon(Icons.star,
                                color: Colors.white70,
                              ),
                              const HorizontalPadding(paddingSize: 3),
                              Padding(padding: const EdgeInsets.only(top:3),
                                  child: Row(
                                    children: [
                                      Text('$farmerRating',
                                        style: GoogleFonts.lato(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const HorizontalPadding(paddingSize: 3),
                                      GestureDetector(
                                          onTap: (){
                                            if(checkIfUser()){
                                              showDialog(context: context,
                                                  builder: (BuildContext context){
                                                    return RatingWidget(farmerDetail: widget.farmerDetail,details: widget.details,ref: widget.ref,);
                                                  });
                                            }
                                            else{
                                              createAccountPopUp(context);
                                            }
                                          },
                                          child: Opacity(opacity: 0.5,
                                            child: Container(
                                              height: 18,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: Colors.white70,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 7,right: 7),
                                                child: Center(
                                                    child: Text(
                                                      'RATE',
                                                      style: GoogleFonts.lato(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                          )
                                      )
                                    ],
                                  )
                              ),

                            ],
                          )
                      ),
                      Positioned(
                        right: 45,
                        top: 200,
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
                                          imageUrl: widget.farmerDetail['profile'] ?? placeholderprofileLink,
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
                          child: Container(
                            height: 100,
                            width: 100,
                            child: CachedNetworkImage(
                              imageUrl: widget.farmerDetail['profile'] ?? placeholderprofileLink,
                              imageBuilder: (context,imageProvider){
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
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
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 45,
                        child:  Row(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.black,
                            ),),
                            const HorizontalPadding(paddingSize: 120),
                            IconButton(onPressed: (){
                              Navigator.push(context,
                                CupertinoPageRoute(builder: (BuildContext context){
                                  return DetailsAdvanced(farmerDetails: widget.farmerDetail);
                                })
                              );
                            }, icon: const Icon(Icons.info,
                              color: Colors.black87,
                              size: 27,)),
                            const HorizontalPadding(paddingSize: 1),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert,size: 27,color: Colors.black87,)),

                          ],
                        ),)
                    ],
                  )
              ),
              const VerticalPadding(paddingSize: 10),
              Expanded(
                // height: 552,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        //Container(),
                        for(var i in items)
                          i,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

    );
  }
}

class AgrItemCard extends StatefulWidget {
  const AgrItemCard({super.key,required this.itemName, required this.itemLink, this.itemStatus });
  final String itemName;
  final String itemLink;
  final dynamic itemStatus;
  @override
  State<AgrItemCard> createState() => _AgrItemCardState();
}

class _AgrItemCardState extends State<AgrItemCard> {
  @override
  Widget build(BuildContext context) {
    String status=(widget.itemStatus==1)?"Available":(widget.itemStatus==2)?"Coming\nSoon":"Out of\nStock";
    Color statusColour=(widget.itemStatus==1)?Colors.green:(widget.itemStatus==2)?Colors.grey:Colors.white;
    Color cardColor= (widget.itemStatus==1 || widget.itemStatus==2)?Color(0xffe1f1e4):Color(0xffa7a7a7);
    Color imageColor=(widget.itemStatus==1 || widget.itemStatus==2)?Colors.white:Color(0xffa7a7a7);

    void viewItem(imageLink){
      showDialog(context: context,
          barrierDismissible: false,
          builder: (Builder){
            return InteractiveViewer(
              constrained: true,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageLink,
                    imageBuilder: (context,imageProvider){
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context,url,error)=>const  Icon(CupertinoIcons.cart,size: 60,),
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
    }
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              HorizontalPadding(paddingSize: 9),
              Container(
                height: 65,
                width: 65,

                child: GestureDetector(
                  onTap: (){viewItem(widget.itemLink);},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          imageColor,
                          BlendMode.modulate

                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.itemLink,
                        fit: BoxFit.cover,
                        //color: cardColor==Color(0xffCDCDCD)?Color(0xffCDCDCD):Colors.green,
                        // ,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  // width: 140,
                  child: Text(
                      widget.itemName,
                      style: GoogleFonts.lato(
                        fontSize: 20
                      )
                  ),
                )),
              Spacer(),
              Container(
                child: Text(status,
                  style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 18,color: statusColour)),
                  textAlign: TextAlign.end,
                ),
              ),
              HorizontalPadding(paddingSize: 9)


            ],
          ),
        ));
  }
}


class RatingWidget extends StatefulWidget {
  RatingWidget({super.key, required this.farmerDetail,required this.details,required this.ref});
  final dynamic farmerDetail;
  final dynamic details;
  final ref;
  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double curRating =5;
  String? farmerId;
  List<String> userRatedFarmers=[];
  @override
  void initState(){
    super.initState();
    farmerId=widget.farmerDetail['id'];
    // userRatedFarmers=widget.details[userId]['rated'].keys.toList();
    if(widget.details[userId]['rated'][farmerId]!=null) {
      curRating = widget.details[userId]['rated'][farmerId].toDouble();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFf5fff7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const VerticalPadding(paddingSize: 15),
              Center(
                  child: DefaultTextStyle(
                    style: const TextStyle(),
                    child: Text('$curRating',
                      style: GoogleFonts.lato(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  )
              ),
              const VerticalPadding(paddingSize: 10),
              RatingBar.builder(
                  initialRating: curRating,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  allowHalfRating: true,
                  glow: false,
                  itemSize: 45,
                  unratedColor: myGreen,
                  itemBuilder: (context, _)=> const Icon(
                    Icons.star,
                    color: Color(0xFF95C19E),
                    // color: Colors.teal,
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                  onRatingUpdate: (rating){
                    setState(() {
                      curRating=rating;
                    });
                    //print('$curRating!');
                  }),
              const Spacer(),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  const HorizontalPadding(paddingSize: 5),
                  TextButton(onPressed: () async {
                    //rating system
                    double noOfRating=widget.farmerDetail['rating']['noOfRating'].toDouble();
                    double rate=widget.farmerDetail['rating']['rate'].toDouble();
                    double userRating=0;
                    String farmerId=widget.farmerDetail['id'];

                    //firebase refernce to farmer and user
                    final _farmerRef = widget.ref.child('details/$farmerId/rating');
                    final _userRef= widget.ref.child('details/$userId/rated');
                    bool success=true,success2=true;
                    double finalRating=rate;

                    //loading animation
                    loadAnimation(context);

                    //user already rated the farmer
                    if(widget.details[userId]['rated'][farmerId]!=null){
                      userRating=widget.details[userId]['rated'][farmerId].toDouble();
                      debugPrint("user already rated: ${widget.details[userId]['rated'][farmerId]}");
                      debugPrint('Farmer Rating: $rate');
                      debugPrint('User prev Rating: $userRating\nUser cur rating: $curRating');

                      //calculations
                      double temp=rate*noOfRating;
                      temp-=userRating;
                      temp+=curRating;
                      finalRating = (temp/noOfRating).toDouble();
                    }

                    // user havent rated the farmer already
                    else{
                      debugPrint('farmer havent rated already');
                      double temp=rate*noOfRating;
                      temp+=curRating;
                      noOfRating=noOfRating+1;
                      temp=(temp/noOfRating);
                      finalRating= temp.toDouble();
                    }
                    //changing info in firebase

                    //changing rating
                    await _farmerRef.update({
                      "noOfRating": noOfRating,
                      "rate": finalRating
                    }).catchError((e){
                      debugPrint(e);
                      success=false;
                      PopUp(context,'$e', 30, Colors.redAccent, FontWeight.w400, "Continue");
                    });

                    //changing user data
                    await _userRef.update({
                      farmerId: curRating
                    }).catchError((e){
                      success2=false;
                      PopUp(context,'$e', 30, Colors.redAccent, FontWeight.w400, "Continue");
                    });

                    if(success && success2) {
                      debugPrint('success');

                      //close animation
                      Navigator.of(context).pop();
                      //closing the rating bar and reloading the page
                      Navigator.of(context).pop();
                      }
                    }, child: Text('RATE',
                    style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  )),

                  //cancel button
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text("CANCEL",
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  )),
                ],
              ),
              const VerticalPadding(paddingSize: 8),
            ],
          ),
        ),
      ),
    );
  }
}



