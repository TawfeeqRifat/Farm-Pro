import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../sample_details.dart';
import 'package:farm_pro/pages/detailsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
class FarmerPage extends StatefulWidget {
  const FarmerPage({super.key,required this.detail, required this.userDetail});
  final dynamic detail;
  final dynamic userDetail;
  @override
  State<FarmerPage> createState() => _FarmerPageState();
}

class _FarmerPageState extends State<FarmerPage> {

  final searchController = TextEditingController();

  String query='';
  List<String> searchResults=details.keys.toList();

  void onQueryChanged(String query){
    setState(() {
      if(query==''){
        searchResults= widget.detail.keys.toList();
      }
      else{
        searchResults.clear();
        for (var i in widget.detail.keys) {
          if (i.toLowerCase().contains(query.toLowerCase())) {
            searchResults.add(i);
          }
        }
      }

      debugPrint(query);
      for(var i in searchResults){
        debugPrint(i);
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
            FarmerPageCard(detail: widget.detail['$i'],userDetail: widget.userDetail,),

        ]
    );
  }

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
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
                          searchResults= widget.detail.keys.toList();
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
        IconButton(onPressed: (){

          Navigator.push(context, CupertinoPageRoute(
              //fullscreenDialog: true  ,
              builder: (context)=> DetailsPage(detail: widget.detail, userDetail: widget.userDetail,)));
        },

            icon: Container(

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
        const VerticalPadding(paddingSize: 1),
      ],
    );
  }
}

class FarmTypeFloat extends StatelessWidget {
  const FarmTypeFloat({super.key,required this.typeName});
  final typeName;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 23,
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
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
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