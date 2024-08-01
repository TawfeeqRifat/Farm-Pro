import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import 'package:farm_pro/Utilities/CustomWidgets.dart';

class SchemeAdvanced extends StatefulWidget {
  const SchemeAdvanced({super.key, required this.scheme});
  final dynamic scheme;
  @override
  State<SchemeAdvanced> createState() => _SchemeAdvancedState();
}

class _SchemeAdvancedState extends State<SchemeAdvanced> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5fff7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const VerticalPadding(paddingSize: 40),
          Row(
            children: [
              const HorizontalPadding(paddingSize: 5),
              Text(
                widget.scheme['heading'],
                style: GoogleFonts.lato(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
          const VerticalPadding(paddingSize: 10),
          SizedBox(
            width: double.infinity,
            height: 729.726,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for(var i in widget.scheme['topics'])
                    Topics(currentTopic: i),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Topics extends StatefulWidget {
  const Topics({super.key, required this.currentTopic});
  final dynamic currentTopic;

  @override
  State<Topics> createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VerticalPadding(paddingSize: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => PdfViewer(pdfLink: widget.currentTopic['pdfLink'],)));
          },
          child: Container(
              height: 60,
              width: 380,
              decoration: BoxDecoration(
                color: const Color(0xffe1f1e4),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  const HorizontalPadding(paddingSize: 5),
                  Text(
                    widget.currentTopic['topicName'],
                    textAlign: TextAlign.start,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async{

                      print('clicked');
                    },
                    icon: const Icon(
                      Icons.download_rounded,
                    ),
                  ),
                  const HorizontalPadding(paddingSize: 5),
                ],
              )),
        )
      ],
    );
  }
}

class PdfViewer extends StatelessWidget {
  const PdfViewer({super.key, required this.pdfLink});
  final String pdfLink;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const PDF(
        swipeHorizontal: false,
        enableSwipe: true,
        autoSpacing: false,
        pageFling: false,
        preventLinkNavigation: true,
      ).cachedFromUrl(
        pdfLink,
        placeholder: (progress)=> Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}

