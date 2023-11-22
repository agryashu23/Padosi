import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

import '../hairSalon/utils/BHColors.dart';

class AdminOffers extends StatefulWidget {
  const AdminOffers({Key? key}) : super(key: key);

  @override
  State<AdminOffers> createState() => _AdminOffersState();
}

class _AdminOffersState extends State<AdminOffers> {

  TextEditingController percentController = TextEditingController();
  TextEditingController offController = TextEditingController();


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("admin").doc("discount").get().then((value){
      percentController.text = value["percent"].toString();
      offController.text = value["off"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.w,top: 15.h),
              child: labelControl("Percent OFF"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller:percentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)
                  ),
                  fillColor: Colors.grey.shade200,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  prefixText: "%",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff8d8d8d),
                  ),
                  prefixIconColor: Color(0xff4f4f4f),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w,top: 15.h),
              child: labelControl("Upto. OFF"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: offController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)
                  ),
                  fillColor: Colors.grey.shade200,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  prefixText: "\u{20B9} ",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff8d8d8d),
                  ),
                  prefixIconColor: Color(0xff4f4f4f),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
                ),
              ),
            ),
            GestureDetector(
              onTap: ()async{
                await FirebaseFirestore.instance.collection("admin").doc("discount").update({
                 "off":int.parse(offController.text),
                  "percent":int.parse(percentController.text),
                });
                Fluttertoast.showToast(msg: "Offers updated successfully");
              },
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30.h),
                  padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 15.h),
                  decoration: BoxDecoration(
                    color: BHColorPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.w),),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
  Widget labelControl(String s){
    return Container(
      child: Text(
        s,
        style: TextStyle(
            color: Colors.black,
            fontSize: 14.w,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2),
      ),
    );
  }
}