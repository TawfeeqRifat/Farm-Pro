import 'dart:async';
import 'dart:ffi';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
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
  SchemesPage({super.key});
  @override
  State<SchemesPage> createState() => _SchemesPageState();
}

class _SchemesPageState extends State<SchemesPage> {
  List<drive.File> _files =[];

  //reading schemes data from firebase
  dynamic _schemes;
  final ref = FirebaseDatabase.instance.ref();
  late StreamSubscription _schemesStream;

  void _getSchemes() async {

    //active fetching
    _schemesStream=ref.child('schemes').onValue.listen((event){
      setState(() {
        _schemes=event.snapshot.value;

      });
    });
  }


  @override
  void initState(){
    super.initState();
    _getSchemes();
    _fetchFiles();
  }

  @override
  void deactivate(){
    super.deactivate();
    _schemesStream.cancel();
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
  // Widget schemesLister(){
  //   List schemeKeys= widget.scheme.keys.toList();
  //   if(schemeKeys.length%2!=0){
  //     schemeKeys.add('0');
  //   }
  //   return Column(
  //     children: [
  //       for(var i=0;i<schemeKeys.length;i=i+2)
  //         schemesSingleRowLister(schemeKeys[i],schemeKeys[i+1])
  //
  //     ],
  //   );
  // }
  Widget schemesLister(){
    // List schemeKeys= widget.scheme.keys.toList();

    return Column(
      children: [
        for(int i=0;i<_schemes.length;i=i+2)
          schemesSingleRowLister(i,i+1,_schemes.length)

      ],
    );
  }
  Widget schemesSingleRowLister(int i,int j,int len){
    return Column(
      children: [
        Row(
          children: [
            const HorizontalPadding(paddingSize: 7),
            SchemeTopic(scheme: _schemes[i]),
            const Spacer(),

            if(j!=len)
              SchemeTopic(scheme: _schemes[j]),
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

                schemesLister() ?? Column(),


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
                    // child: Image.network(
                    //   scheme['image']!,
                    //   fit: BoxFit.cover,
                    // ),
                    child: CachedNetworkImage(
                      imageUrl: scheme['image']!,
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
                      errorWidget: (context,url,error)=>const  Icon(Icons.hourglass_disabled_sharp,size: 35,),
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
