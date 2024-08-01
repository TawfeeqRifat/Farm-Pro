import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_pro/Pages/Farmers_pages/detailsAdvanced.dart';
import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.detail,required this.userDetail});
  final dynamic detail;
  final dynamic userDetail;
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
    if(widget.detail['rating']['rate']<1.0){
      farmerRating='---';
    }
    else{
      farmerRating=widget.detail['rating']['rate'].toStringAsFixed(2);
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
                          Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context)=>DetailsAdvanced(farmerDetails: widget.detail)));
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
                      //Image.network(widget.detail['farm_images'][0]),
                      Positioned(
                          top: 130,
                          left: 15,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, CupertinoPageRoute(builder: (BuildContext)=>DetailsAdvanced(farmerDetails: widget.detail)));
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
                                Text(widget.detail['name'],
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
                              IconButton(onPressed: ()async{
                                String p=widget.detail['contact_details']['pno'];
                                Uri phone=Uri.parse('tel:$p');
                                if(await launchUrl((phone))){
                                  debugPrint("can dial");
                                }
                                else{
                                  debugPrint('cannot dial');
                                }
                              }, icon: Icon(Icons.phone)),
                              IconButton(onPressed: ()async{
                                String mail=widget.detail['contact_details']['mail_id'];
                                Uri email=Uri.parse('mailto:$mail');
                                await launchUrl(email);
                              }, icon: Icon(Icons.mail_outline)),
                              const HorizontalPadding(paddingSize: 4),
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
                                            showDialog(context: context,
                                                builder: (BuildContext context){
                                                  return RatingWidget(detail: widget.detail,userDetail: widget.userDetail,);
                                                });
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
                          child: Container(
                            height: 100,
                            width: 100,
                            child: CachedNetworkImage(
                              imageUrl: widget.detail['profile'],
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
                                  return DetailsAdvanced(farmerDetails: widget.detail);
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
              SizedBox(
                height: 552,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Container(),
                      for(var i in items)
                        i,
                    ],
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
    String status=(widget.itemStatus==1)?'Available':(widget.itemStatus==2)?'Coming Soon':'Out of Stock';
    Color statusColour=(widget.itemStatus==1)?Colors.green:(widget.itemStatus==2)?Colors.grey:Colors.white;
    Color cardColor= (widget.itemStatus==1 || widget.itemStatus==2)?Color(0xffe1f1e4):Color(0xffa7a7a7);
    Color imageColor=(widget.itemStatus==1 || widget.itemStatus==2)?Colors.white:Color(0xffa7a7a7);
    return Padding(padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
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
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: 140,
                  child: Text(
                      widget.itemName,
                      style: GoogleFonts.lato(
                        fontSize: 20
                      )
                  ),
                )),
              Container(
                width: 100,
                child: Flexible(
                  child: Text(status,
                    style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 18,color: statusColour)),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),


            ],
          ),
        ));
  }
}


class RatingWidget extends StatefulWidget {
  RatingWidget({super.key, required this.detail,required this.userDetail});
  final dynamic detail;
  final dynamic userDetail;
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
    farmerId=widget.detail['id'];
    userRatedFarmers=widget.userDetail['rated'].keys.toList();
    if(widget.userDetail['rated'][farmerId]!=null) {
      curRating = widget.userDetail['rated'][farmerId];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            color: const Color(0xFFf5fff7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const VerticalPadding(paddingSize: 10),
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
              const VerticalPadding(paddingSize: 5),
              RatingBar.builder(
                  initialRating: curRating,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  allowHalfRating: true,
                  glow: false,
                  itemBuilder: (context, _)=> const Icon(
                    Icons.star,
                    color: Color(0xFF95C19E),
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
                  TextButton(onPressed: (){

                    //rating system

                      setState(() {
                      double noOfRating=widget.detail['rating']['noOfRating'].toDouble();
                      double rate=widget.detail['rating']['rate'].toDouble();
                      double userRating=0;
                      String farmerId=widget.detail['id'];

                      //user already rated the farmer
                      if(widget.userDetail['rated'][farmerId]!=null){
                        userRating=widget.userDetail['rated'][farmerId].toDouble();
                          //debugPrint('Farmer Rating: $rate');
                          //debugPrint('User prev Rating: $userRating\nUser cur rating: $curRating');
                          double temp=rate*noOfRating;
                          temp-=userRating;
                          temp+=curRating;
                          widget.detail['rating']['rate']=(temp/noOfRating).toDouble();
                          widget.userDetail['rated'].update(farmerId,(value)=>curRating.toDouble());
                          //widget.userDetail['rated'][farmerId]=(curRating).toDouble();
                          //debugPrint('Changed farmer Rating; ${widget.detail['rating']['rate']}');
                          //debugPrint('Changed User Rating: ${widget.userDetail['rated'][farmerId]}');
                      }

                      //user havent rated the farmer already
                      else{
                        debugPrint('this working-else');
                        setState(() {
                              double temp=rate*noOfRating;
                              temp+=curRating;
                              noOfRating=noOfRating+1;
                              temp=(temp/noOfRating);
                              widget.detail['rating']['rate']=temp.toDouble();
                              widget.detail['rating']['noOfRating']=noOfRating.toInt();
                              widget.userDetail['rated'][farmerId]=curRating.toDouble();
                              //debugPrint('new Rating: ${widget.detail['rating']['rate']}\n new noOfRating: ${widget.detail['rating']['noOfRating']}');
                              //debugPrint('userRating: ${widget.userDetail['rated'][farmerId]}');
                        });
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context)=>DetailsPage(detail: widget.detail, userDetail: widget.userDetail,),)
                      );
                      });
                    }, child: Text('RATE',
                    style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  )),
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
              const VerticalPadding(paddingSize: 10),
            ],
          ),
        ),
      ),
    );
  }
}

