import 'dart:io';
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
class ShopPage extends StatefulWidget {
  ShopPage({super.key,required this.ref, this.mode});
  final ref;
  String? mode;
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  //used with mode, indicate text box editability
  late bool editable;

  saveChanges(){

  }

  modeChangeButton(){

    //view mode, suggest edit button
    if(widget.mode=="view-mode"){
      return TextButton(
        onPressed: (){
          setState(() {
            widget.mode="edit-mode";
            editable=true;
          });
        },
        style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
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
                Icons.edit_rounded,
                color: darkerGreen,
                size: 30,
              )
            ],
          ),
        ),
      );
    }

    //edit button,suggest save
    else{
      return TextButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext){
                return Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: myBackground,
                    ),
                    child: Column(
                      children: [
                        VerticalPadding(paddingSize: 59),
                        DefaultTextStyle(
                            style: GoogleFonts.lato(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            child: const Text(
                              'Confirm Changes?',
                              textAlign: TextAlign.center,
                            )
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            //discard
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.mode="view-mode";
                                  editable=false;
                                  // getDetails();
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: darkerGreen),
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w700,
                                        color: myBackground,
                                        fontSize: 25,
                                      ),
                                      child: const Text(
                                        'Discard',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                              ),
                            ),

                            HorizontalPadding(paddingSize: 8),

                            GestureDetector(
                              onTap: () {
                                saveChanges();
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: darkerGreen),
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w700,
                                        color: myBackground,
                                        fontSize: 25,
                                      ),
                                      child: const Text(
                                        'Confirm',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            HorizontalPadding(paddingSize: 8),

                          ],
                        ),
                        VerticalPadding(paddingSize: 8),
                      ],
                    ),
                  ),
                );
              }
          );
        },
        style: ButtonStyle(shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Text(
                'Save ',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: darkerGreen
                ),
              ),
              Icon(
                Icons.save_rounded,
                color: darkerGreen,
                size: 30,
              )
            ],
          ),
        ),
      );
    }
  }

  List <TextEditingController> cardControllers=[];
  List <TextEditingController> statusController=[];
  List<bool> errorConditions=[];
  List<bool> statusErrorConditions=[];

  void addCard(){
    print("workds");
    setState(() {
      TextEditingController Controller=TextEditingController();
      TextEditingController stController=TextEditingController();
      errorConditions.add(false);
      statusErrorConditions.add(false);
      cardControllers.add(Controller);
      statusController.add(stController);

    });
  }

  void removeCard(int pos){
    print("removed");
    if(cardControllers.length>1) {
      setState(() {
        errorConditions.removeAt(pos);
        statusErrorConditions.removeAt(pos);
        cardControllers.removeAt(pos);
        statusController.removeAt(pos);
      });
    }
    print(cardControllers.length);
  }

  @override
  void initState(){
    widget.mode='view-mode';
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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

                modeChangeButton(),
              ],
            ),

            VerticalPadding(paddingSize: 20),

            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      ListView.builder(
                          itemCount: cardControllers.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,int index){
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    GestureDetector(
                                      onTap: (){
                                        removeCard(index);
                                      },
                                      child: Row(
                                        children: [

                                          Icon(Icons.delete,color: Colors.green.shade300,),
                                          Text("Delete"),
                                          // Icon(CupertinoIcons.trash_fill),

                                        ],
                                      ),
                                    ),
                                    HorizontalPadding(paddingSize: 8),
                                  ],
                                ),
                                VerticalPadding(paddingSize: 8),
                                newItemCard(Controller: cardControllers[index],errorCondition: errorConditions[index],statusErrorCondition: statusErrorConditions[index],statusController: statusController[index],),
                              ],
                            );

                          }
                      ),
                      //add item
                      GestureDetector(
                        onTap: (){
                          addCard();
                        },
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
                      ),
                      VerticalPadding(paddingSize: 20),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}

class newItemCard extends StatefulWidget {
  newItemCard({super.key,required this.Controller,required this.errorCondition, required this.statusErrorCondition, required this.statusController});
  final Controller;
  var errorCondition;
  final statusErrorCondition;
  final statusController;
  @override
  State<newItemCard> createState() => _newItemCardState();
}

class _newItemCardState extends State<newItemCard> {

  var status;
  var statusColor=Colors.green;


  //Imagepicker for image
  String? _selectedFilePath;

  void _pickProfile()async{
    showCupertinoModalBottomSheet(
      expand: false,

      context: context,
      builder: (context) => Container(
        height: 250,
        // width: ,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 150),
                child: CustomDivider(color: Colors.green,thickness: 5,)
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: Row(
                  children: [
                    DefaultTextStyle(
                        style: GoogleFonts.lato(
                            color: Colors.green,
                            fontSize: 30,
                            fontWeight: FontWeight.w700
                        ),
                        child: Text('Profile Photo')
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _selectedFilePath=null;
                          });
                          Navigator.of(context).pop();
                        },
                        icon: Icon(CupertinoIcons.trash,color: Colors.green,))
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //camera
                  GestureDetector(
                    onTap: (){
                      getImage(2);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          CircleAvatar(backgroundColor: myGreen,foregroundColor: myGreen,radius: 30,child: Icon(CupertinoIcons.camera,color: Colors.green, size: 40,)),
                          VerticalPadding(paddingSize: 5),
                          DefaultTextStyle(
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                              ),
                              child: Text('Camera')
                          ),
                        ],
                      ),
                    ),
                  ),

                  //gallery
                  GestureDetector(
                    onTap: (){
                      getImage(1);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        children: [
                          CircleAvatar(backgroundColor: myGreen,foregroundColor: myGreen,radius: 30,child: Icon(Icons.photo_camera_back,color: Colors.green, size: 40,)),
                          VerticalPadding(paddingSize: 5),
                          DefaultTextStyle(
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                              ),
                              child: Text('Gallery')
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),

      ),
    );
  }

  Future<void> getImage(int i) async {
    final profile;

    //galley
    if(i==1){
      profile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(profile!=null) {
        setState(() {
          _selectedFilePath = profile?.path ?? _selectedFilePath;
        });
        Cropper();
      }
      else{
        //if user cancel, permission denied
        Navigator.of(context).pop();
      }
    }

    //camera
    else if(i==2){
      profile = await ImagePicker().pickImage(source: ImageSource.camera);
      if(profile!=null) {
        setState(() {
          _selectedFilePath = profile?.path ?? _selectedFilePath;
        });
        Cropper();
      }
      else{
        //if user cancel, permission denied
        Navigator.of(context).pop();
      }
    }
  }

  //Image cropping
  var croppedImage;
  final imageController= CropController(
      aspectRatio: 1,
      defaultCrop: Rect.fromLTRB(0.1, 0.1, 0.9, 0.9)
  );
  void Cropper(){
    showDialog(context: context, builder: (BuildContext){
      return Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 150),
                    child: CropImage(
                      controller: imageController,
                      image: Image.file(File(_selectedFilePath!)),
                    ),
                  ),
                ),
              ),

              Positioned(
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: DefaultTextStyle(
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white54,
                                ),
                                child: Text('Cancel'),
                              )
                          ),
                        ),
                        Spacer(),

                        //rotate
                        IconButton(
                            onPressed: imageController.rotateLeft,
                            icon: Icon(Icons.rotate_90_degrees_ccw,color: Colors.white54,size: 25,)
                        ),
                        Spacer(),

                        //done
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: GestureDetector(
                              onTap: () async {
                                final img= await imageController.croppedImage();

                                //storing in local storage to get path
                                var bitmap = await imageController.croppedBitmap();
                                var data=await bitmap.toByteData(format: ImageByteFormat.png);
                                var bytes = data!.buffer.asUint8List();
                                await File(_selectedFilePath!).writeAsBytes(bytes);

                                setState(() {
                                  croppedImage= img;
                                });
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                              },
                              child: DefaultTextStyle(
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white54,
                                ),
                                child: Text('Done '),
                              )
                          ),
                        ),
                      ],
                    ),
                    VerticalPadding(paddingSize: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  //image showing widget
  Widget showProfile(){
    if(_selectedFilePath!=null){
      return
        Container(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: croppedImage,
          ),
        );
    }
    else{
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: myBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          CupertinoIcons.cart_fill,
          size: 30,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        Container(
          height: 100,
          decoration: BoxDecoration(
            color: myGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              HorizontalPadding(paddingSize: 8),

              //item img
              GestureDetector(
                onTap: () async {
                  print(_selectedFilePath);
                  try{
                    _pickProfile();
                    print("workds");
                  } on Exception catch(e){
                    print(e);
                  }
                  print(_selectedFilePath);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 60,width: 60,
                    ),
                    Positioned(child: CircleAvatar(backgroundColor: myGreen,radius: 30,)),
                    showProfile(),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: myGreen
                        ),
                        child: Icon(
                          CupertinoIcons.camera_circle_fill,
                          color: darkerGreen,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                )
              ),

              Spacer(),

              SizedBox(
                height: 80,
                width: 120,
                child: Center(
                  child: TextField(
                    controller: widget.Controller,
                    onChanged: (String value){
                      setState((){
                        widget.errorCondition=false;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkerGreen)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green.shade100)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent.shade100)
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent.shade100)
                      ),
                      fillColor: Colors.green.shade50,
                      filled: true,
                      hintText: 'Item Name',
                      hintStyle: GoogleFonts.lato(
                        // color: Colors.green.shade400,
                          color: Colors.black26
                      ),
                      errorText: ((widget.errorCondition!=null && widget.errorCondition==true)? "Can't be Empty": null)?? null,

                    ),
                    cursorColor: Colors.teal,
                    showCursor: true,
                  ),
                ),
              ),

              Spacer(),

              DropdownMenu(
                onSelected: (item){
                  setState(() {
                    status=item;
                    if(status==1) statusColor=Colors.green;
                    else if(status==2) statusColor= Colors.grey;
                    else if(status==3) statusColor=Colors.red;
                  });
                },
                dropdownMenuEntries: const <DropdownMenuEntry<int>>[
                  DropdownMenuEntry(value: 1, label: "Available" ),
                  DropdownMenuEntry(value: 2, label: "Coming Soon", ),
                  DropdownMenuEntry(value: 3, label: "Out of Stock", )
                ],
                width: 120,
                textStyle: GoogleFonts.lato(
                  color: statusColor,
                  fontSize: 12,
                ),
                requestFocusOnTap: true,
                initialSelection: 1,
                inputDecorationTheme: const InputDecorationTheme(
                  
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC8E6C9))
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF95C19E))
                  ),
                  contentPadding: EdgeInsets.only(left: 8),
                  helperMaxLines: 2,


                ),

                trailingIcon: Icon(Icons.keyboard_arrow_down_rounded,size: 20,),
                selectedTrailingIcon: Icon(Icons.keyboard_arrow_up_rounded,size: 20,),
                label: Text('Item Status',style: GoogleFonts.lato(fontSize: 12,color: Colors.black),maxLines: 2,),
                menuStyle: MenuStyle(
                  backgroundColor:WidgetStateProperty.resolveWith((states) {
                    return myGreen;
                  }),
                ),
                enableSearch: false,

                hintText: 'Item Status',
                errorText: widget.statusErrorCondition==true?"State Not selected": null,
                controller: widget.statusController,
              ),
              HorizontalPadding(paddingSize: 8),


            ],
          ),
        ),

        VerticalPadding(paddingSize: 20),
      ],
    );
  }
}

// _pickProfile(_selectedFilePath,context,croppedImage)async{
//   showCupertinoModalBottomSheet(
//     expand: false,
//
//     context: context,
//     builder: (context) => Container(
//       height: 250,
//       // width: ,
//       decoration: BoxDecoration(
//         // borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 150),
//               child: CustomDivider(color: Colors.green,thickness: 5,)
//           ),
//           Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
//               child: Row(
//                 children: [
//                   DefaultTextStyle(
//                       style: GoogleFonts.lato(
//                           color: Colors.green,
//                           fontSize: 30,
//                           fontWeight: FontWeight.w700
//                       ),
//                       child: Text('Profile Photo')
//                   ),
//                   Spacer(),
//                   IconButton(
//                       onPressed: (){
//                         _selectedFilePath=null;
//                         Navigator.of(context).pop();
//                       },
//                       icon: Icon(CupertinoIcons.trash,color: Colors.green,))
//                 ],
//               )
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 //camera
//                 GestureDetector(
//                   onTap: (){
//                     getImage(2,_selectedFilePath,context,croppedImage);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(backgroundColor: myGreen,foregroundColor: myGreen,radius: 30,child: Icon(CupertinoIcons.camera,color: Colors.green, size: 40,)),
//                         VerticalPadding(paddingSize: 5),
//                         DefaultTextStyle(
//                             style: GoogleFonts.lato(
//                                 color: Colors.green,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w700
//                             ),
//                             child: Text('Camera')
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 //gallery
//                 GestureDetector(
//                   onTap: (){
//                      getImage(1,_selectedFilePath,context,croppedImage);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 40.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(backgroundColor: myGreen,foregroundColor: myGreen,radius: 30,child: Icon(Icons.photo_camera_back,color: Colors.green, size: 40,)),
//                         VerticalPadding(paddingSize: 5),
//                         DefaultTextStyle(
//                             style: GoogleFonts.lato(
//                                 color: Colors.green,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w700
//                             ),
//                             child: Text('Gallery')
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//           )
//         ],
//       ),
//
//     ),
//   );
// }
//
// Future<(dynamic, dynamic )?> getImage(int i,_selectedFilePath,context,croppedImage) async {
//   final profile;
//
//   //galley
//   if(i==1){
//     profile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if(profile!=null) {
//       _selectedFilePath = profile?.path ?? _selectedFilePath;
//       return (_selectedFilePath,Cropper(croppedImage,_selectedFilePath,context));
//     }
//     else{
//       //if user cancel, permission denied
//       Navigator.of(context).pop();
//     }
//   }
//
//   //camera
//   else if(i==2){
//     profile = await ImagePicker().pickImage(source: ImageSource.camera);
//     if(profile!=null) {
//       _selectedFilePath = profile?.path ?? _selectedFilePath;
//       return (_selectedFilePath, Cropper(croppedImage,_selectedFilePath,context));
//     }
//     else{
//       //if user cancel, permission denied
//       Navigator.of(context).pop();
//     }
//   }
// }
//
// dynamic Cropper(croppedImage,_selectedFilePath,context){
//   final imageController= CropController(
//       aspectRatio: 1,
//       defaultCrop: Rect.fromLTRB(0.1, 0.1, 0.9, 0.9)
//   );
//   showDialog(context: context, builder: (BuildContext){
//     return Center(
//       child: Container(
//         height: double.infinity,
//         width: double.infinity,
//         color: Colors.black,
//         child: Stack(
//           children: [
//             Center(
//               child: Container(
//                 height: double.infinity,
//                 width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 150),
//                   child: CropImage(
//                     controller: imageController,
//                     image: Image.file(File(_selectedFilePath!)),
//                   ),
//                 ),
//               ),
//             ),
//
//             Positioned(
//               child: Column(
//                 children: [
//                   Spacer(),
//                   Row(
//                     children: [
//
//                       Padding(
//                         padding: const EdgeInsets.only(left: 15.0),
//                         child: GestureDetector(
//                             onTap: (){
//                               Navigator.of(context).pop();
//                               Navigator.of(context).pop();
//                             },
//                             child: DefaultTextStyle(
//                               style: GoogleFonts.lato(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white54,
//                               ),
//                               child: Text('Cancel'),
//                             )
//                         ),
//                       ),
//                       Spacer(),
//
//                       //rotate
//                       IconButton(
//                           onPressed: imageController.rotateLeft,
//                           icon: Icon(Icons.rotate_90_degrees_ccw,color: Colors.white54,size: 25,)
//                       ),
//                       Spacer(),
//
//                       //done
//                       Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: GestureDetector(
//                             onTap: () async {
//                               final img= await imageController.croppedImage();
//
//                               //storing in local storage to get path
//                               var bitmap = await imageController.croppedBitmap();
//                               var data=await bitmap.toByteData(format: ImageByteFormat.png);
//                               var bytes = data!.buffer.asUint8List();
//                               await File(_selectedFilePath!).writeAsBytes(bytes);
//
//
//                               croppedImage= img;
//                               Navigator.of(context).pop();
//                               Navigator.of(context).pop();
//                               return croppedImage;
//                             },
//                             child: DefaultTextStyle(
//                               style: GoogleFonts.lato(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white54,
//                               ),
//                               child: Text('Done '),
//                             )
//                         ),
//                       ),
//                     ],
//                   ),
//                   VerticalPadding(paddingSize: 20),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   });
// }
