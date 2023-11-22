import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as Path;
import 'package:salon/hairSalon/screens/load_widget.dart';

import '../../hairSalon/utils/BHColors.dart';

class OwnerGallery extends StatefulWidget {
  static String tag = '/OwnerGallery';

  @override
  State<OwnerGallery> createState() => _OwnerGalleryState();
}

class _OwnerGalleryState extends State<OwnerGallery> {
  // List<File> selectedImages = [];

  // Future getImages() async {
  //   final pickedFile = await picker.pickMultiImage(
  //       imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
  //   List<XFile> xfilePick = pickedFile;
  //   setState(
  //         () {
  //       if (xfilePick.isNotEmpty) {
  //         for (var i = 0; i < xfilePick.length; i++) {
  //           selectedImages.add(File(xfilePick[i].path));
  //         }
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Nothing is selected')));
  //       }
  //     },
  //   );
  // }
  bool loading=false;
  firebase_storage.Reference? ref;
  CollectionReference? imgRef;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        loading=true;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('owners/${Path.basename(imageTemp.path)}');
      await ref!.putFile(imageTemp).whenComplete(() async {
        await ref!.getDownloadURL().then((value) async {
          imgRef?.add({"url": value});
          setState(() {
            FirebaseFirestore.instance.collection("owners").doc(FirebaseAuth.instance.currentUser!.uid).update({
              "gallery":FieldValue.arrayUnion([value])});
          });
        });
      });
      setState(() {
        loading= false;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title:Text("Gallery",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body:loading?BHLoading(): FutureBuilder(
        future:FirebaseFirestore.instance.collection("owners").doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var value = snapshot.data!;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
              child: GridView.builder(
                  gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 130.w,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h),
                  itemCount: value['gallery'].length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(value['gallery'][index],width: 130.w,height: 130.h,fit: BoxFit.cover,)),
                          Align(
                            alignment:Alignment.topRight,
                            child: GestureDetector(
                                onTap: ()async{
                                  if(value["gallery"].length>1){
                                    await FirebaseFirestore.instance.collection("owners").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                      "gallery":FieldValue.arrayRemove([value['gallery'][index]])
                                    });
                                    String fileUrl =Uri.decodeFull(Path.basename(value['gallery'][index])).replaceAll(RegExp(r'(\?alt).*'), '');
                                    firebase_storage.Reference ref = FirebaseStorage.instance.ref().child(fileUrl);
                                    await ref.delete();
                                    setState(() {

                                    });
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: "Need to have atleast one image");
                                  }

                                },
                                child: Icon(Icons.delete,color: Colors.red,size: 30.w,)),
                          )
                        ],
                      ),
                    );
                  }),
            );
          }
          else{
            return BHLoading();
          }

        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: BHColorPrimary,
        onPressed: () async{
          await pickImage();
          setState(() {
          });
        },
      ),
    );
  }
}
