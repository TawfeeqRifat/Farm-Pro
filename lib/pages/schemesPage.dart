import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gradient/image_gradient.dart';

import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/pages/schemeAdvanced.dart';

import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;


final _client = http.Client();

Future<List<drive.File>> fetchFilesInFolder(String folderId) async {
  final driveApi = drive.DriveApi(_client);
  final files = <drive.File>[];

  try {
    final response = await driveApi.files.list(q: "'$folderId' in parents");
    files.addAll(response.files!);
    return files;
  } finally {
    _client.close();
  }
}

class SchemesPage extends StatefulWidget {
  SchemesPage({super.key, required this.scheme});
  final dynamic scheme;
  @override
  State<SchemesPage> createState() => _SchemesPageState();
}

class _SchemesPageState extends State<SchemesPage> {
  List<drive.File> _files =[];

  @override
  void initState(){
    super.initState();
    _fetchFiles();
  }

  Future<void> _fetchFiles() async{
    try {
      final folderId = 'https://drive.google.com/drive/folders/1KvTdUw21neNZACCbB4DShrqKi-L5LoPZ?usp=drive_link';
      final files = await fetchFilesInFolder(folderId);
      setState(() {
        _files = files;
        print(_files.length);
      });
    } catch(error){
      print ('Error fetching files: $error');
    }

  }
  Widget schemesLister(){
    List schemeKeys= widget.scheme.keys.toList();
    if(schemeKeys.length%2!=0){
      schemeKeys.add('0');
    }
    return Column(
      children: [
        for(var i=0;i<schemeKeys.length;i=i+2)
          schemesSingleRowLister(schemeKeys[i],schemeKeys[i+1])

      ],
    );
  }
  Widget schemesSingleRowLister(var i,var j){
    return Column(
      children: [
        Row(
          children: [
            const HorizontalPadding(paddingSize: 7),
            SchemeTopic(scheme: widget.scheme['$i']),
            const Spacer(),

            if(j!='0')
              SchemeTopic(scheme: widget.scheme['$j'],),
            const HorizontalPadding(paddingSize: 7),
          ],
        ),
        const VerticalPadding(paddingSize: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VerticalPadding(paddingSize: 15,),
        SizedBox(
          height: 664.7271,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,

              children: [
                  /*Row(
                    children: [
                      const HorizontalPadding(paddingSize: 7),
                      SchemeTopic(scheme: widget.scheme['1']),
                      const Spacer(),
                      SchemeTopic(scheme: widget.scheme['2'],),
                      HorizontalPadding(paddingSize: 7),
                    ],
                  ),*/
                schemesLister(),



              ],
            ),
          ),
        )
      ],
    );

  }
}

class SchemeTopic extends StatelessWidget {
  const SchemeTopic({super.key, required this.scheme});
  final dynamic scheme;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.push(context, CupertinoPageRoute(
          builder: (context)=> SchemeAdvanced(scheme: scheme,))),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 120,
          width: 170,
          child: Stack(
            children: [
              Container(
                height: 120,
                width: 170,
                decoration: BoxDecoration(
                ),
                child:  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      scheme['image']!,
                      fit: BoxFit.cover,
                    ),
                  )
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: SizedBox(
                    width:160,
                    child: Stack(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(scheme['heading'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            textStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = Colors.black
                          ),
                        ),
                        Text(scheme['heading'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                          ),),
                      ],
                    ),
                  )
              )
            ],
          )
        ),
      )
    );
  }
}
