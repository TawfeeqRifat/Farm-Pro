import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_pro/Pages/Authentication_pages/FarmerForm.dart';
import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  TextEditingController controller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              VerticalPadding(paddingSize: 30),

              Row(
                children: [
                  Text(
                    'Shop',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.green
                    ),
                  ),
                  Spacer(),

                  //edit button
                  TextButton(
                    onPressed: (){},
                    style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
                    child: Row(
                      children: [
                        Text(
                          'Edit ',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: darkerGreen
                          ),
                        ),
                        Icon(
                          Icons.edit_outlined,
                          color: darkerGreen,
                          size: 30,
                        )
                      ],
                    ),
                  )
                ],
              ),

              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: myGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    children: [
                      HorizontalPadding(paddingSize: 9),
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          CupertinoIcons.cart_fill,
                          size: 35,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 80,
                            width: 200,
                            child: CusTextBoxAlone(controller: controller)),
                      ),
                      Container(
                        width: 100,
                        child: Flexible(
                          child: Text('Status',
                            style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 18,color: Colors.red)),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              //add item
              GestureDetector(
                onTap: (){},
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Colors.green.shade300,
                  radius: Radius.circular(8),
                  dashPattern: [10,8,6,4,2],
                  child: SizedBox(
                    height: 90,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                          'ADD ITEM',
                        style: GoogleFonts.lato(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
