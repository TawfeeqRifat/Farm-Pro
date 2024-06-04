import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:farm_pro/Utilities/CustomWidgets.dart';


class DetailsCard extends StatefulWidget {
  const DetailsCard({super.key,required this.details});
  final dynamic details;

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkTeal,
      body: DraggableScrollableSheet(
          initialChildSize: 0.87,
          minChildSize: 0.87,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,

              child: Container(
                width: 500,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  color: Color(0xFF26a69a),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VerticalPadding(paddingSize: VerticalPadSize),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(35)),
                                child: Image.network(widget.details['profile'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                left: 250,
                                top: 20,
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: lightTeal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const VerticalPadding(paddingSize: 17),

                    Text(widget.details['name'],
                        style: GoogleFonts.signikaNegative(
                          textStyle: MyTextTheme.bodyMedium,
                        )),

                    VerticalPadding(paddingSize: VerticalPadSize-10),

                    Row(
                      children: [
                        HorizontalPadding(paddingSize: HorizontalPadSize),
                        Text('Contacts:',
                            style: GoogleFonts.signikaNegative(
                              textStyle: MyTextTheme.displayMedium,
                            )),],
                    ),
                    Row(
                      children: [
                        HorizontalPadding(paddingSize: HorizontalPadSize*3),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for(var i in widget.details['contact_details'])
                              Text('$i',
                                style: GoogleFonts.signikaNegative(
                                  textStyle: MyTextTheme.displayMedium,
                                ),
                              )
                          ],
                        ),

                      ],
                    ),

                    //farming type-ish dunno the word
                    VerticalPadding(paddingSize: VerticalPadSize-10),

                    Row(
                      children: [
                        HorizontalPadding(paddingSize: HorizontalPadSize),
                        Text('Farm Type:',
                            style: GoogleFonts.signikaNegative(
                              textStyle: MyTextTheme.displayMedium,
                            )),],
                    ),
                    const VerticalPadding(paddingSize: 5),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:[
                          HorizontalPadding(paddingSize: HorizontalPadSize*3),
                          for(var i in widget.details['farm_type'])
                            FarmTypeFloater(typeName: i),
                        ],
                      ),

                    ),

                    //about

                    CustomDivider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HorizontalPadding(paddingSize: HorizontalPadSize),
                        Text("ABOUT",
                            style: GoogleFonts.signikaNegative(
                              textStyle: MyTextTheme.bodyLarge,
                            )),
                      ],
                    ),
                    VerticalPadding(paddingSize: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HorizontalPadding(paddingSize: HorizontalPadSize),
                        Text(widget.details['about'],
                            style: GoogleFonts.signikaNegative(
                              textStyle: MyTextTheme.bodySmall,
                            )),
                      ],
                    ),

                    //farm images
                    CustomDivider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HorizontalPadding(paddingSize: HorizontalPadSize),
                        Text("Farm Images",
                            style: GoogleFonts.signikaNegative(
                              textStyle: TextStyle(
                                color: myWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 42,
                              ),
                            )),
                      ],
                    ),
                    VerticalPadding(paddingSize: VerticalPadSize),
                    Container(
                      height: 320,
                      width: double.infinity,

                      child: FarmImageWidget(links: widget.details['farm_images']),
                    ),
                    //FarmImageWidget(),

                    VerticalPadding(paddingSize: VerticalPadSize),



                    VerticalPadding(paddingSize: 150),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class FarmImageWidget extends StatefulWidget {
  const FarmImageWidget({super.key,required this.links});
  final links;
  @override
  State<FarmImageWidget> createState() => _FarmImageWidgetState();
}

class _FarmImageWidgetState extends State<FarmImageWidget> {
  PageController controller=PageController();
  int _curr=0;
  final temp='https://lostinanime.com/wp-content/uploads/2023/01/Vinland-Saga-Season-2-02-25.jpg';
  @override
  Widget build(BuildContext context) {
    return PageView(
      allowImplicitScrolling: true,
      scrollDirection: Axis.horizontal,
      controller: controller,
      onPageChanged: (num){
        setState(() {
          _curr=num;
        });
      },
      children: [
        for(var i in widget.links)
          FarmPage(link: i),
      ],);
  }
}


class FarmPage extends StatelessWidget {
  const FarmPage({super.key,required this.link});
  final link;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HorizontalPadding(paddingSize: 10),
        SizedBox(
          height: 300,
          width: 350,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Image.network(
                link,
                fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}

class FarmTypeFloater extends StatelessWidget {
  const FarmTypeFloater({super.key,required this.typeName});
  final typeName;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 28,
          child: Row(
            children: [
              HorizontalPadding(paddingSize: 5),
              Text('$typeName',
                  style: GoogleFonts.signikaNegative(
                    textStyle: MyTextTheme.displaySmall,
                  )),
              HorizontalPadding(paddingSize: 5),
            ],
          ),
          decoration: BoxDecoration(
            color: shiningTeal,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        HorizontalPadding(paddingSize: 15),
      ],
    );
  }
}



