import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:nb_utils/nb_utils.dart';
import 'dart:io';
import 'package:toggle_switch/toggle_switch.dart';

import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/BHImages.dart';
import 'load_widget.dart';

class BHAccountInformationScreen extends StatefulWidget {
  static String tag = '/AccountInformationScreen';
  BHAccountInformationScreen({required this.urlImage2});

  final String urlImage2;

  @override
  BHAccountInformationScreenState createState() => BHAccountInformationScreenState();
}

class BHAccountInformationScreenState extends State<BHAccountInformationScreen> {
  TextEditingController fullNameCont = TextEditingController();
  TextEditingController dOBCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneNumCont = TextEditingController();
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode dOBFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneNumFocusNode = FocusNode();
  String gender="male";
  File? image2;
  bool loading=false;

  firebase_storage.Reference? ref;
  String urlImage="";
  CollectionReference? imgRef;


  Future uploadFiles() async {
    ref = firebase_storage.FirebaseStorage.instance.ref().child('users/${Path.basename(image2!.path)}');
    await ref!.putFile(image2!).whenComplete(() async{
      await ref!.getDownloadURL().then((value) async {
        imgRef?.add({"url":value});
        setState(() {
          urlImage = value;
        });
      }
      );
    }
    );
  }
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        image2 = imageTemp;
        urlImage = image2!.path;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }


  Future getInfo()async{
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      phoneNumCont.text = value['phone'];
      if(value.data()!.containsKey("name")){
        fullNameCont.text = value["name"];
      }
      if(value.data()!.containsKey("gender")){
        gender = value["gender"];
      }
      if(value.data()!.containsKey("DOB")){
        dOBCont.text = value["DOB"];
      }
      if(value.data()!.containsKey("image")){
        urlImage = value["image"];
      }
      if(value.data()!.containsKey("email")){
        emailCont.text = value["email"];
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: whiteColor,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              finish(context);
            },
            child: Icon(Icons.arrow_back, color: blackColor),
          ),
          title: Text(BHTxtAccountInformation, style: TextStyle(color: BHAppTextColorPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: loading?Center(child: CircularProgressIndicator(),):FutureBuilder(
        future:getInfo(),
        builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done ) {
      return Container(
        color: BHGreyColor.withOpacity(0.1),
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await pickImage(
                      ImageSource.gallery);
                },
                child: Container(
                    margin: EdgeInsets.only(top: 50.h),
                    child: image2!=null
                        ? CircleAvatar(
                        backgroundImage: FileImage(image2!),
                        radius: 45):urlImage == "" ? CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Center(child: Icon(
                          Icons.add, color: Colors.white, size: 30.w,),),
                        radius: 45) :
                    CircleAvatar(
                        backgroundImage:
                        NetworkImage(urlImage),
                        radius: 45)
                ),
              ),

              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(offset: Offset(0.0, 1.0),
                        color: BHGreyColor.withOpacity(0.3),
                        blurRadius: 2.0),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullNameCont,
                      focusNode: fullNameFocusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(dOBFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(color: BHGreyColor, fontSize: 14),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                      ),
                    ),
                    12.height,
                    ToggleSwitch(
                      minWidth: 90.0,
                      initialLabelIndex: gender == "male" ? 0 : 1,
                      cornerRadius: 20.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      labels: ['Male', 'Female'],
                      icons: [Icons.male, Icons.female],
                      activeBgColors: [[Colors.blue], [Colors.pink]],
                      onToggle: (index) {
                        index == 0 ? gender = "male" : gender = "female";
                      },
                    ),
                    10.height,
                    TextFormField(
                      controller: dOBCont,
                      focusNode: dOBFocusNode,
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(emailFocusNode);
                      },
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                        labelText: "Date of Birth",
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1960, 8),
                              lastDate: DateTime(2050),
                            );
                            if (pickedDate != null) {
                              String formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(pickedDate);
                              // setState(() {
                                dOBCont.text = formattedDate;
                              // });
                              print(dOBCont.text);
                            } else {
                              print("Date is not selected");
                            }
                          },
                          child: Icon(
                              Icons.calendar_today, color: BHColorPrimary,
                              size: 20.w),
                        ),
                        labelStyle: TextStyle(color: BHGreyColor, fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: emailCont,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(phoneNumFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: BHGreyColor, fontSize: 14),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                      ),
                    ),
                    TextFormField(
                      controller: phoneNumCont,
                      focusNode: phoneNumFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(color: BHGreyColor, fontSize: 14),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                      ),
                    ),
                    24.height,
                    Container(
                      padding: EdgeInsets.all(0),
                      color: BHColorPrimary,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.45,
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            loading=true;
                          });
                          image2 != null ? await uploadFiles() : null;
                          await FirebaseFirestore.instance.collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "name": fullNameCont.text,
                            "gender": gender,
                            "DOB": dOBCont.text,
                            "email": emailCont.text,
                            "image": urlImage,
                          });
                          setState(() {
                            loading=false;
                          });

                          Fluttertoast.showToast(msg: "Details Updated Successfully");
                          // BHDashedBoardScreen().launch(context);
                        },
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        child: Text("Update Details", style: TextStyle(
                            color: whiteColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{
      return BHLoading();
    }
        }
      ),
    );
  }
}
