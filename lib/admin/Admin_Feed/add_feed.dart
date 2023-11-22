import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as Path;
import 'package:salon/admin/Admin_Feed/show_feed.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:io';

class AddFeed extends StatefulWidget {
  const AddFeed({Key? key}) : super(key: key);

  @override
  State<AddFeed> createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {
  TextEditingController titleController = TextEditingController();
  TextEditingController feedController = TextEditingController();
  File? image2;
  firebase_storage.Reference? ref;
  String urlImage = "";
  CollectionReference? imgRef;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        image2 = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  Future uploadFiles() async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('feeds/${Path.basename(image2!.path)}');
    await ref!.putFile(image2!).whenComplete(() async {
      await ref!.getDownloadURL().then((value) async {
        imgRef?.add({"url": value});
        setState(() {
          urlImage = value;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Feed"),
        backgroundColor: BHColorPrimary,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              ShowFeed().launch(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.w,top: 6.h,bottom: 6.h),
              color: Colors.blue.shade500,
              width: 70.w,
              alignment: Alignment.center,
              child: Text("Show"),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width:180.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: BHColorPrimary,
                ),
                child: TextButton(
                  onPressed: () async{
                    await pickImage();
                  },
                  child: Text("Add Image", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            image2==null?Container():Container(
              height: 100.h,
              width: context.width(),
              child: Image.file(image2!),
            ),
            8.height,
            Text("Title",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.w,letterSpacing: 0.4),),
            8.height,
            TextFormField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Add Title",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            15.height,
            Text("Feed",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.w,letterSpacing: 0.4),),
            8.height,
            Expanded(
              child: TextField(
                controller: feedController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)),
                  fillColor: Colors.grey.shade200,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  hintText: "Add Feed",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff8d8d8d),
                  ),
                  prefixIconColor: Color(0xff4f4f4f),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: BHColorPrimary)),
                ),
              ),
            ),
            10.height,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: BHColorPrimary,
              ),
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () async{
                  if(titleController.text.isEmpty || feedController.text.isEmpty || image2==null){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Enter All Fields"),));
                  }
                  else{
                    image2 != null ? await uploadFiles() : null;
                    await FirebaseFirestore.instance.collection("feeds").add({
                        "title":titleController.text,
                         "feed":feedController.text,
                          "image":urlImage
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Feed Added Successfuly"),));
                    setState(() {
                      titleController.clear();
                      feedController.clear();
                      image2 = null;
                      urlImage="";
                    });
                  }
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text("Add", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),


          ],
        ),
      ),

    );
  }
}
