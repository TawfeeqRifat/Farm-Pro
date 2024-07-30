import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'farmersPage.dart';

class DetailsAdvanced extends StatefulWidget {
  const DetailsAdvanced({super.key,required this.farmerDetails});
  final dynamic farmerDetails;
  @override
  State<DetailsAdvanced> createState() => _DetailsAdvancedState();
}

class _DetailsAdvancedState extends State<DetailsAdvanced> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackground,
      
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: myBackground,
        automaticallyImplyLeading: false,
        actions: [
          Padding(padding: EdgeInsets.only(right: 10),
            child: IconButton(onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close,
              size: 40,
                color: darkTeal,
              )
            )
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FARMER',
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const VerticalPadding(paddingSize: 15),
                    Text(widget.farmerDetails['name'],
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CustomDivider(
                      color: darkTeal,
                      thickness: 3,
                    ),
                    VerticalPadding(paddingSize: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: ()async{
                            String p=widget.farmerDetails['contact_details']['pno'];
                            Uri phone=Uri.parse('tel:$p');
                            if(await launchUrl((phone))){
                              debugPrint("can dial");
                            }
                            else{
                              debugPrint('cannot dial');
                            }
                          },
                              icon: Icon(Icons.phone,
                                color: lightTeal,
                              )
                          ),
                          const HorizontalPadding(paddingSize: 5),
                          IconButton(onPressed: ()async{
                            String mail=widget.farmerDetails['contact_details']['mail_id'];
                            Uri email=Uri.parse('mailto:$mail');
                            await launchUrl(email);
                          }, icon: Icon(Icons.mail_outline,
                            color: lightTeal,
                          )
                          ),
                        ]
                    ),
                    const VerticalPadding(paddingSize: 10),
                    Text('Domain',
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const VerticalPadding(paddingSize: 5),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:[
                            const HorizontalPadding(paddingSize: 4),
                            for(var i in widget.farmerDetails['farm_type'])
                              FarmTypeFloat(typeName: i,myheight: 30,myFontSize: 15,myColor: Colors.white),
                          ],
                        ),),
                    ),
                    const VerticalPadding(paddingSize: 10),
                    Text('Description',
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    VerticalPadding(paddingSize: 5),
                    Padding(padding: EdgeInsets.only(left: 8),
                      child: Text(widget.farmerDetails['about'],
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    VerticalPadding(paddingSize: 30),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: myGreen,
                      ),
                    ),
                    VerticalPadding(paddingSize: 5),
                    InkWell(
                      onTap: ()async{
                        Uri _url=Uri.parse("https://www.google.com/maps?ll=10.728578,79.01826&z=19&t=m&hl=en&gl=US&mapclient=embed&cid=447860320795505436");
                        if(await launchUrl(_url)){
                          await launchUrl(_url);
                        }
                        else{

                        }
                      },
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(widget.farmerDetails['address'],
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: lightTeal
                          ),
                        ),
                      ),
                    ),
                    VerticalPadding(paddingSize: 30)
                  ],
                ),
              ),
        )
      )
    );
  }
}
