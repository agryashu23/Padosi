import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

import '../../main/utils/AppWidget.dart';



class AdminServiceCategory extends StatefulWidget {
  const AdminServiceCategory({Key? key}) : super(key: key);

  @override
  State<AdminServiceCategory> createState() => _AdminServiceCategoryState();
}

class _AdminServiceCategoryState extends State<AdminServiceCategory> {
  TextEditingController titleController = TextEditingController();
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
        .child('service_category/${Path.basename(image2!.path)}');
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
        backgroundColor: BHColorPrimary,
        title: Text("Service Category"),
        centerTitle:true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            25.height,
            GestureDetector(
              onTap: ()async{
                await pickImage();
              },
              child: Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: BHColorPrimary,
                  radius: 47,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 45,
                    child: image2 == null
                        ? CircleAvatar(
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.grey,
                        // backgroundImage:
                        // Image.network(BHWalkThroughImg1).image,
                        radius: 43)
                        : CircleAvatar(
                        radius: 43,
                        backgroundImage: FileImage(image2!)),
                  ),
                ),
              ),
            ),

            30.height,
            Text("Title",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.w,letterSpacing: 0.2),),
            10.height,
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
            30.height,
            Container(
              margin: EdgeInsets.only(left: 100.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: BHColorPrimary,
              ),
              child: TextButton(
                onPressed: () async {
                  if (titleController.text.isEmpty || image2==null) {
                    Fluttertoast.showToast(msg: "Enter All Details");
                  }
                  else {
                    await uploadFiles();
                    await FirebaseFirestore.instance.collection("category").add(
                        {
                          "name": titleController.text,
                          "image": urlImage,
                        });
                    titleController.clear();
                    image2 == null;
                    Fluttertoast.showToast(msg: "Category Added Successfully");
                  }
                },
                child: Text("Add Category", style: TextStyle(color: whiteColor, fontSize: 16.w, fontWeight: FontWeight.bold)),
              ),
            ),
            40.height,
            SingleChildScrollView(
              child: SizedBox(
                height: 300.h,
                child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection("category").get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var value = snapshot.data!.docs;
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                                padding: EdgeInsets.only(bottom: 3.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: BHGreyColor.withOpacity(0.3),
                                        offset: Offset(0.0, 1.0),
                                        blurRadius: 2.0)
                                  ],
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        child: commonCacheImageWidget(value[index]["image"], 50.h,
                                            width: 60.w, fit: BoxFit.fitWidth),
                                      ),
                                      Text(
                                        value[index]["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: BHAppTextColorPrimary,
                                            fontSize: 14),
                                      ),
                                      GestureDetector(
                                        onTap: ()async{
                                          await FirebaseFirestore.instance.collection("category").doc(value[index].id).delete();
                                          setState(() {
                                          });
                                          // await deleteImage(value[index]["image"]);
                                          FirebaseStorage.instance.refFromURL(value[index]["image"]).delete();
                                        },
                                        child: Container(
                                          width: 70.w,
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: BHColorPrimary,
                                                decoration: TextDecoration.underline,
                                                fontSize: 16.w),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      }
                      else{
                        return Center(child: Text("No Categories"),);
                      }
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl)).replaceAll(new RegExp(r'(\?alt).*'), '');
    final firebase_storage.Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child("service_category/$fileUrl");
    await firebaseStorageRef.delete();
  }

}
