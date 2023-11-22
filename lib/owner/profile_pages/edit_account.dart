import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../hairSalon/utils/BHColors.dart';
import '../../hairSalon/utils/BHImages.dart';
import '../../hairSalon/utils/widget_constant.dart';
import '../../main/utils/AppWidget.dart';
import '../location_class.dart';

class OwnerEditAccount extends StatefulWidget {
  static String tag = '/OwnerEditAccount';

  @override
  State<OwnerEditAccount> createState() => _OwnerEditAccountState();
}

class _OwnerEditAccountState extends State<OwnerEditAccount> {
  List<Locations> locations = [];
  String status = '';
  int status2=0;
  String dropdownValue = "Documents";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController alternateContactController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  String capacity = "";
  int gender=0;
  List<String> Items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  firebase_storage.Reference? ref;
  String urlImage = "";
  CollectionReference? imgRef;

  File? image2;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
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
        .child('owners/${Path.basename(image2!.path)}');
    await ref!.putFile(image2!).whenComplete(() async {
      await ref!.getDownloadURL().then((value) async {
        imgRef?.add({"url": value});
        setState(() {
          urlImage = value;
        });
      });
    });
  }

  // _getLocations(pincode) async {
  //     status = 'Please wait...';
  //   final JsonDecoder _decoder = const JsonDecoder();
  //   await http
  //       .get(Uri.parse("http://www.postalpincode.in/api/pincode/$pincode"))
  //       .then((http.Response response) {
  //     final String res = response.body;
  //     final int statusCode = response.statusCode;
  //
  //     if (statusCode < 200 || statusCode > 400) {
  //       throw Exception("Error while fetching data");
  //     }
  //
  //
  //       var json = _decoder.convert(res);
  //       var tmp = json['PostOffice'] as List;
  //     setState(() {
  //       locations =
  //           tmp.map<Locations>((json) => Locations.fromJson(json)).toList();
  //       status = 'All Locations at Pincode ' + pincode;
  //     });
  //   });
  // }

  Future getInfo()async{
    await FirebaseFirestore.instance
        .collection("owners")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value){
      contactController.text = value['phone'];
      nameController.text = value["salon_name"];
      gender = value["gender"];
      urlImage = value["image"];
      status2 = value["status"];
      if (value.data()!.containsKey("email")) {
        emailController.text = value["email"];
      }
      if (value.data()!.containsKey("alternate_contact")) {
        alternateContactController.text = value["alternate_contact"];
      }
      addressController.text = value["address"];
      if (value.data()!.containsKey("pincode")) {
        pincodeController.text = value["pincode"];
      }
      cityController.text = value["city"];
      if (value.data()!.containsKey("about")) {
        aboutController.text = value["about"];
      }
      capacity = value["capacity"];

      if (value.data()!.containsKey("about")) {
        aboutController.text = value["about"];
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future:getInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          commonCacheImageWidget(
                              BHWalkThroughImg3, context.height() * 0.22,
                              width: context.width(), fit: BoxFit.fitWidth),
                          GestureDetector(
                            onTap: () async {
                              await showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 140.h,
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Choose Profile Picture',
                                            style: TextStyle(fontSize: 20.0),
                                          ),
                                          20.height,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                children: [
                                                  IconButton(
                                                    iconSize: 70,
                                                    icon: const Icon(
                                                        Icons.camera),
                                                    onPressed: () async {
                                                      await pickImage(
                                                          ImageSource.camera);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  Text('Camera')
                                                ],
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Column(
                                                children: [
                                                  IconButton(
                                                    iconSize: 70,
                                                    icon:
                                                        const Icon(Icons.image),
                                                    onPressed: () async {
                                                      await pickImage(
                                                          ImageSource.gallery);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  Text('Gallery'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  top: context.height() * 0.155),
                              child: CircleAvatar(
                                backgroundColor: BHColorPrimary,
                                radius: 49,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 47,
                                  child: image2!=null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(image2!),
                                          radius: 45)
                                      : urlImage==""?CircleAvatar(backgroundColor: Colors.grey,radius: 45,child: Icon(
                                    Icons.add, color: Colors.white, size: 30.w,),):CircleAvatar(
                                          radius: 45,
                                          backgroundImage:
                                              NetworkImage(urlImage)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                          child: Container(
                        margin: EdgeInsets.only(top: 10.h),
                        child: Text(
                          "Edit Information",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.w,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway'),
                        ),
                      )),
                      10.height,
                      Center(
                        child: ToggleSwitch(
                          minWidth: 90.w,
                          initialLabelIndex: status2,
                          cornerRadius: 10.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: ['Open', 'Closed'],
                          icons: [Icons.shop, Icons.close],
                          activeBgColors: [[Colors.red],[Colors.red]],
                          onToggle: (index) {
                            status2= index!;
                          },
                        ),
                      ),
                      // FlutterSwitch(
                      //   activeText: "Open",
                      //   inactiveText: "Closed",
                      //   value: status2,
                      //   activeTextFontWeight: FontWeight.bold,
                      //   activeColor: BHColorPrimary,
                      //   valueFontSize: 10.0,
                      //   width: 75.w,
                      //   borderRadius: 30.0,
                      //   showOnOff: true,
                      //   onToggle: (val) {
                      //     setState(() {
                      //       status2 = val;
                      //     });
                      //   },
                      // ),
                      labelText("Salon Name"),
                Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w,top: 0),
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixStyle: TextStyle(fontSize: 16),
                      fillColor: Colors.grey.shade200,
                      isDense:true,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xff8d8d8d),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIconColor: Color(0xff4f4f4f),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                    ),
                    validator: (value) {
                      if (value != null) {
                        return null;
                      } else
                        return 'Field cannot be empty';
                    },
                  ),
                ),
                      5.height,
                      labelText("Contact Number"),
                Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w,top: 0),
                  child: TextFormField(
                    controller: contactController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixStyle: TextStyle(fontSize: 16),
                      fillColor: Colors.grey.shade200,
                      isDense:true,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xff8d8d8d),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIconColor: Color(0xff4f4f4f),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                    ),
                    validator: (value) {
                      if (value != null) {
                        return null;
                      } else
                        return 'Field cannot be empty';
                    },

                  ),
                ),
                      5.height,
                      labelText("Email Address"),
                      forms(controller: emailController, choice: "Alpha"),
                      labelText("Alternate Contact Number"),
                      forms(
                          controller: alternateContactController,
                          choice: "Number"),
                      5.height,
                      labelText("Complete Address"),
                      Container(
                        margin: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: TextFormField(
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 7.h),
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color(0xff8d8d8d),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIconColor: Color(0xff4f4f4f),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: BHAppDividerColor)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: BHAppDividerColor)),
                          ),
                        ),
                      ),
                      5.height,
                      labelText("Salon For"),
                      10.height,
                      Center(
                        child: ToggleSwitch(
                          minWidth: 90.w,
                          initialLabelIndex: gender,
                          cornerRadius: 10.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 3,
                          labels: ['Male', 'Female',"Both"],
                          icons: [Icons.male, Icons.female,Icons.transgender],
                          activeBgColors: [[Colors.blue],[Colors.pink],[Colors.green]],
                          onToggle: (index) {
                            gender = index!;
                          },
                        ),
                      ),
                      5.height,

                      labelText("Pincode"),
                      Container(
                        margin: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: TextFormField(
                          controller: pincodeController,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 7.h),
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color(0xff8d8d8d),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIconColor: Color(0xff4f4f4f),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: BHAppDividerColor)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: BHAppDividerColor)),
                          ),
                          validator: (value) {
                            if (pincodeController.text.length == 6) {
                              return null;
                            }
                            return "Enter Valid Pincode";
                          },
                        ),
                      ),
                      5.height,

                      labelText("City"),
                  Container(
                    margin: EdgeInsets.only(left: 20.w, right: 20.w,top: 0),
                    child: TextFormField(
                      controller: cityController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixStyle: TextStyle(fontSize: 16),
                        fillColor: Colors.grey.shade200,
                        isDense:true,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color(0xff8d8d8d),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconColor: Color(0xff4f4f4f),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                      ),
                      validator: (value) {
                        if (value != null) {
                          return null;
                        } else
                          return 'Field cannot be empty';
                      },
                    ),
                  ),
                      labelText("Select Capacity of Salon"),
                      Container(
                        width: 300.w,
                        height: 40.h,
                        margin: EdgeInsets.only(left: 20.w, top: 10.h),
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          isDense: true,
                          hint:  Text(
                            capacity==""?'Capacity':capacity,
                            style: TextStyle(fontSize: 14),
                          ),
                          items: Items.map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              )).toList(),
                          onChanged: (value) {
                            capacity = value.toString();
                          },
                          onSaved: (value) {
                            capacity = value.toString();
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 60,
                            padding: EdgeInsets.only(left: 0, right: 10),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                          ),
                        ),
                      ),
                      5.height,
                      labelText("About"),
                      Container(
                        margin: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: TextFormField(
                          controller: aboutController,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 7.h),
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color(0xff8d8d8d),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIconColor: Color(0xff4f4f4f),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: BHAppDividerColor)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: BHAppDividerColor)),
                          ),
                        ),
                      ),
                      24.height,
                      Center(
                        child: Container(
                          color: BHColorPrimary,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextButton(
                            onPressed: () async{
                              image2 != null ? await uploadFiles() : null;
                              await FirebaseFirestore.instance.collection("owners")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "name": nameController.text,
                                "gender": gender,
                                "email": emailController.text,
                                "image": urlImage,
                                "status":status2,
                                "alternate_contact":alternateContactController.text,
                                "address":addressController.text,
                                "pincode":pincodeController.text,
                                "city":cityController.text,
                                "capacity":capacity,
                                "about":aboutController.text,
                              });
                              Fluttertoast.showToast(msg: "Details Updated Successfully");

                            },
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Text("Update Details",
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      // labelText("State"),
                      // forms(controller: stateController, choice: "Alpha"),
                      SizedBox(
                        height: 200.h,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: BHLoading(),
              );
            }
          }),
    );
  }
}
