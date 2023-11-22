import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:io';

import '../../hairSalon/utils/BHColors.dart';

class AddServiceOwner extends StatefulWidget {
  const AddServiceOwner({Key? key}) : super(key: key);

  @override
  State<AddServiceOwner> createState() => _AddServiceOwnerState();
}

class _AddServiceOwnerState extends State<AddServiceOwner> {
  TextEditingController serviceName = TextEditingController();
  TextEditingController servicePrice = TextEditingController();
  TextEditingController serviceDuration = TextEditingController();
  final List<String> Items = [
    'Hair Cutting',
    'Hair Styling',
    'Hair Styli',
    'Hair Styl',
  ];
  String selectedValue="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Service"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w),
        child: Column(
          children: [
            30.height,
            TextFormField(
              controller: serviceName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Service Name",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            20.height,
            DropdownButtonFormField2(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              isExpanded: true,
              isDense:true,
              hint: const Text(
                'Select Category',
                style: TextStyle(fontSize: 14),
              ),
              items: Items
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
                  .toList(),
              onChanged: (value) {
                selectedValue = value.toString();
              },
              onSaved: (value) {
                selectedValue = value.toString();
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
            20.height,
            TextFormField(
              controller: servicePrice,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Service Price",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            15.height,
            TextFormField(
              controller: serviceDuration,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Service Duration (in min)",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            20.height,
            Center(
              child: Container(
                color: BHColorPrimary,
                width: MediaQuery.of(context).size.width*0.45,
                child: TextButton(
                  onPressed: () async{
                    FocusManager.instance.primaryFocus?.unfocus();
                    if(serviceName.text.isEmpty || serviceDuration.text.isEmpty || servicePrice.text.isEmpty || selectedValue==""){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.tealAccent,
                        duration: Duration(seconds: 2),
                        content: Text("Please enter all fields"),));
                    }
                    else{
                      await FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid).collection("service").add({
                        "name": serviceName.text,
                        "category": selectedValue,
                        "price": servicePrice.text,
                        "duration": serviceDuration.text,
                      });
                      Fluttertoast.showToast(msg: "Service added successfully");
                      serviceName.clear();
                      servicePrice.clear();
                      serviceDuration.clear();
                      selectedValue=="";
                      Navigator.of(context).pop();
                    }
                  },
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: Text("Add Service", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
