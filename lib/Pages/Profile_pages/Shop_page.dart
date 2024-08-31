import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_image/crop_image.dart';
import 'package:farm_pro/Utilities/CustomWidgets.dart';
import 'package:farm_pro/Utilities/custom.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';

import '../../customFunction.dart';
import '../../global_variable.dart';
import '../Farmers_pages/detailsPage.dart';

class ShopPage extends StatefulWidget {
  ShopPage({super.key,required this.ref, this.mode,required this.farmerDetails});
  final ref;
  final farmerDetails;
  String? mode;
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  //used with mode, indicate text box editability
  late bool editable;

  saveChanges() async {

    Navigator.pop(context);

    bool error=false;
    for(int i=0;i<itemList.length;i++){
        if(itemList[i].Controller.text.isEmpty){
          print('$i : empty');
          setState(() {
            // errorConditions[i]=true;
            itemList[i].errorCondition=true;
            // itemList[i].errorCalled();
            PopUp(context,"Item Name cant be empty!");
          });
          error=true;
          break;
        }
        else{
          // errorConditions[i]=false;
        }
    }
    if(!error){

      List<String?> imageLinks=[];

      //the list of name permanent names for the items in storage
      List<String> statuses=[];

      //saving itemImages in firebase Storage
      final _storage = FirebaseStorage.instance;

      loadAnimation(context);


      print("outside loop");
      for(int i=0;i<itemList.length;i++){

        //item have image
        if(itemList[i].imagepathController.text.isNotEmpty){
          print("imagefound");

          //item already existed
          if(itemList[i].status!=null){
            statuses.add(itemList[i].status);

            final path="Farmers/${userId}/${itemList[i].status}";
            final ref= FirebaseStorage.instance.ref().child(path);

            //deleting previous
            try{
              await ref.delete();
            } on FirebaseException catch (e){
              //element not found in db
            }

            //uploading new image
            try{
              await ref.putFile(File(itemList[i].imagepathController.text));
            } on FirebaseException catch (e){

              //closing animation
              Navigator.pop(context);

              PopUp(context,'$e');

            }
            final url= await ref.getDownloadURL();
            imageLinks.add(url);

            print("Uploaded");
            print(ref);
            print(path);
            print(url);
          }

          //item is new
          else{
            statuses.add(itemList[i].Controller.text);

            final path="Farmers/${userId}/${itemList[i].Controller.text}";
            final ref= FirebaseStorage.instance.ref().child(path);
            try{
              await ref.putFile(File(itemList[i].imagepathController.text));
            } on FirebaseException catch (e) {

              //closing animation
              Navigator.pop(context);

              PopUp(context,'$e');

            }
            final url= await ref.getDownloadURL();
            imageLinks.add(url);

            print("Uploaded");
            print(ref);
            print(path);
            print(url);
          }
        }
        else{
          //item doesnt have image
          print("imagenotfound");

          if(itemList[i].status!=null) {
            statuses.add(itemList[i].status);
          }
          else{
            statuses.add(itemList[i].Controller.text);
          }

          print('image is not there');
          if(itemList[i].imageLink!=null) {
            print('but image found in db');
            imageLinks.add(itemList[i].imageLink);
          }
          else {
            imageLinks.add(null);
          }
          // for(int j=0;j<itemList.length;j++){
          //   print('$j : ${imageLinks[j]}');
          // }
        }
      }
      print("once again oustide");
      for(int i=0;i<itemList.length;i++){
        print('$i : ${imageLinks[i]}');
      }

      Map<String,Map<String,String?>> shopdata=Map();

      for(int i=0;i<itemList.length;i++){

          shopdata[statuses[i]] = {
            "itemLink": imageLinks[i],
            "itemName": itemList[i].Controller.text,
            "itemStatus": itemList[i].statusController.text
          };
      }
      print(shopdata);

      //updating the realtime database
      final databaseref = widget.ref;
      databaseref.update({
        "shop" : shopdata
      });

      //deleting all the images not referenced anymore in database
      final storageRef = _storage.ref().child("Farmers/$userId");
      final listResult = await storageRef.listAll();
      print("printing inside data");
      for(var i in listResult.items){
        var fileNames=i.fullPath.split('/');
        var fileName=fileNames[fileNames.length -1];
        print('filename: $fileName');
        var val=statuses.contains(fileName);
        print('item found at $val');
        if(!val){
          print("elem not found");
        final ref= FirebaseStorage.instance.ref().child(i.fullPath);
        //deleting previous
        try{
          await ref.delete();
        }
        on FirebaseException catch (e){}
        }
      }

      //closing load
      Navigator.pop(context);

      PopUp(context,'Shop Updated!',fontcolor: Colors.black);

      setState(() {
        widget.mode='view-mode';
        editable=false;
        getViewModedata();
      });

    }
  }

  modeChangeButton(){

    //view mode, suggest edit button
    if(widget.mode=="view-mode"){
      return TextButton(
        onPressed: (){
          setState(() {
            widget.mode="edit-mode";
            editable=true;
            getEditModeData();
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
                                getViewModedata();
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
                                getViewModedata();
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

  List <TextEditingController> nameControllers=[];
  List <TextEditingController> statusController=[];
  List <TextEditingController> imagePathControllers=[];
  List<newItemCard> itemList =[];
  List<bool> errorConditions=[];
  void addCard(){
    print("workds");
    setState(() {
      // TextEditingController Controller=TextEditingController();
      // Controller.text="";
      // TextEditingController stController=TextEditingController();
      // TextEditingController im=TextEditingController();
      // errorConditions.add(false);
      // nameControllers.add(Controller);
      // statusController.add(stController);
      // imagePathControllers.add(im);

      itemList.add(newItemCard(status: null));
    });
    print("new size: ${itemList.length}");
  }

  void removeCard(int pos){
    print("removed");
    if(itemList.length>1) {
      setState(() {
        // errorConditions.removeAt(pos);
        // nameControllers.removeAt(pos);
        // statusController.removeAt(pos);
        // imagePathControllers.removeAt(pos);
        itemList.removeAt(pos);
        print("removed at $pos");
      });
    }
    print(itemList.length);
    for(int i=0;i<itemList.length;i++){
      print("$i:");
      print("namecontroller: ${itemList[i].Controller.text}");
      print("stController: ${itemList[i].statusController.text}");
      print("Image Contoller: ${itemList[i].imagepathController.text}");
    }
  }

  List<AgrItemCard> viewItems=[];

  // DatabaseReference ref= FirebaseDatabase.instance.ref('Details/$userId');
  // ref.onValue.listen( (DatabaseEvent )
  //
  // );
  //get view mode data



  getViewModedata(){
    viewItems=[];
    // details=ref.value;
    if(farmerDetails['shop']!=null){
      for(dynamic i in farmerDetails['shop'].keys){
        setState(() {
          viewItems.add(
              AgrItemCard(
                itemName: farmerDetails['shop'][i]['itemName'],
                itemLink: farmerDetails['shop'][i]['itemLink'],
                itemStatus: farmerDetails['shop'][i]['itemStatus'],
              )
          );
        });
      }
    }
  }

  //get edit mode data
  getEditModeData(){
    itemList=[];
    print("edit mode data extracted");
    if(farmerDetails['shop']!=null){
      for(var i in farmerDetails['shop'].keys){
        setState(() {
          itemList.add(newItemCard(status: i,));
          itemList.last.Controller.text=farmerDetails['shop'][i]['itemName'];
          itemList.last.statusController.text=farmerDetails['shop'][i]['itemStatus'];
          itemList.last.imageLink=farmerDetails['shop'][i]['itemLink'];
        });
        print("$i item:");
        print(farmerDetails['shop'][i]['itemLink']);
      }
    }
  }

  viewOrEditItems(){
    if(!editable){
      return Column(
        children: [
          for(var i in viewItems)
            i,
        ],
      );
    }
    else{
      return Column(
      children: [

        ListView.builder(
          itemCount: itemList.length,
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
                    ],
                  ),
                ),
                HorizontalPadding(paddingSize: 8),
              ],
              ),
              VerticalPadding(paddingSize: 8),
              itemList[index],
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
      );
    }
  }

  DatabaseReference dbValueChangedref = FirebaseDatabase.instance.ref('details/$userId');

  dynamic farmerDetails;
  @override
  void initState(){
    widget.mode='view-mode';
    editable=false;


    dbValueChangedref.onValue.listen((DatabaseEvent event) {
      setState(() {
        farmerDetails = event.snapshot.value;
        print(farmerDetails);
      });
      getViewModedata();
    });



    //get editmode data
    // getEditModeData();
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

            //displays view or Edit Items based on the mode
            Expanded(
                child: SingleChildScrollView(
                  child: viewOrEditItems(),
                )
            )

          ],
        ),
      ),
    );
  }
}

class newItemCard extends StatefulWidget {
  newItemCard({super.key, required this.status});
  final status;

  @override
  State<newItemCard> createState() => _newItemCardState();

  TextEditingController Controller=TextEditingController();
  bool errorCondition=false;
  TextEditingController statusController=TextEditingController();
  TextEditingController imagepathController = TextEditingController();
  String? imageLink;
}

class _newItemCardState extends State<newItemCard> {

  var status;
  var statusColor=Colors.green;

  //Imagepicker for image
  String? _selectedFilePath=null;


  void _pickProfile()async{
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      builder: (context) => Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
                            widget.imagepathController.text="";
                            widget.imageLink=null;
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
          widget.imagepathController.text = profile?.path ?? _selectedFilePath;
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
          widget.imagepathController.text = profile?.path ?? _selectedFilePath;
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
      defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9)
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

                        //canel
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
                                final img=await imageController.croppedImage();

                                //storing in local storage to get path
                                var bitmap = await imageController.croppedBitmap();
                                var data=await bitmap.toByteData(format: ImageByteFormat.png);
                                var bytes = data!.buffer.asUint8List();
                                await File(_selectedFilePath!).writeAsBytes(bytes);

                                setState(() {
                                  croppedImage=img;
                                });

                                // setState(() {
                                //   img=Image.file(File(widget._selectedFilePath!));
                                // });
                                // await File("${temp.path}/image${widget.ind}.png").writeAsBytes((bytes));
                                  // croppedImage=Image(image: FileImage(File(widget._selectedFilePath!)));
                                // setState(() {
                                //   croppedImage=Image.file(File("${temp.path}/image${widget.ind}.png"));
                                // });
                                // print("${temp.path}/image${widget.ind}.png");
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

  existingImageorNoImage(){
    //the the image is stored in db
    if(widget.imageLink!=null ){
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: myBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(imageUrl: widget.imageLink!,),
        )
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
  //image showing widget
  Widget showProfile(){
    if(_selectedFilePath!=null){
      return
        Container(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: croppedImage
          ),
        );
    }
    else{
      return existingImageorNoImage();
    }
  }

  @override
  void dispose(){
    super.dispose();
    print("item disposed");
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
                  print("${widget.Controller.text}:  ${_selectedFilePath}");
                  try{
                    _pickProfile();
                    print("imagepath of${widget.Controller.text}: ${widget.imagepathController.text}");
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
                    autofocus: false,
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
                initialSelection: widget.statusController.text=="Available"? 1: widget.statusController.text=="Coming Soon"? 2 : widget.statusController.text=="Out of Stock"? 3 : 1,
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
