import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import '../hairSalon/utils/BHColors.dart';
import '../hairSalon/utils/BHConstants.dart';
import '../main/utils/AppWidget.dart';

class OwnerShowAppointment extends StatefulWidget {
  const OwnerShowAppointment({Key? key,required this.id, required this.bookingID, required this.userId}) : super(key: key);
  final String id;
  final int bookingID;
  final String userId;

  @override
  State<OwnerShowAppointment> createState() => _OwnerShowAppointmentState();
}

class _OwnerShowAppointmentState extends State<OwnerShowAppointment> {
  String code="";
  bool loading =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment No. #${widget.bookingID}"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: loading?BHLoading():FutureBuilder(
          future:FirebaseFirestore.instance.collection("salon_bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").doc(widget.id).get(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child:CircularProgressIndicator());
            }
            else if(!snapshot.hasData){
              return Center(child: Text("No data",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
            }
            else {
              var value= snapshot.data!;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: [
                          value["user_image"]==""?Container(width: 80.w,):ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                            child: commonCacheImageWidget(
                                value["user_image"], 60.h,
                                width: 80.w, fit: BoxFit.cover),
                          ),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [
                              Container(
                                width: 130.w,
                                child: Text(value["user_name"]??"",
                                    style: TextStyle(
                                        fontSize: 14.w,
                                        color: BHAppTextColorPrimary,
                                        fontWeight: FontWeight.bold)),
                              ),
                              8.height,
                              Container(
                                width: 140.w,
                                child: Text(
                                  value["user_phone"],
                                  style: TextStyle(
                                      fontSize: 14.w,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400 ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      25.height,
                      Container(
                        padding: EdgeInsets.all(8.w),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Booking Date and Time",
                              style: TextStyle(
                                  color: BHColorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Booking date-",
                                    style: TextStyle(
                                        color: BHAppTextColorSecondary,
                                        fontSize: 14)),
                                Text(DateFormat('yyyy-MM-dd')
                                    .format(value["booking_time"].toDate()),
                                    style: TextStyle(
                                        color: BHColorPrimary,
                                        fontSize: 14)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Booking time-",
                                    style: TextStyle(
                                        color: BHAppTextColorSecondary,
                                        fontSize: 14)),
                                Text(DateFormat.jm().format(value["booking_time"].toDate()).toString(),
                                    style: TextStyle(
                                        color: BHColorPrimary,
                                        fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      15.height,
                      Container(
                        width: 340.w,
                        padding: EdgeInsets.all(8.w),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Services",
                              style: TextStyle(
                                  color: BHColorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            8.height,
                            ...List.generate(value["name"].length, (idx){
                              return Text(value["name"][idx],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400));
                            }),
                          ],
                        ),
                      ),
                      15.height,
                      Container(
                        padding: EdgeInsets.all(8.w),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pricing",
                              style: TextStyle(
                                  color: BHColorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Amount",
                                    style: TextStyle(
                                        color: BHAppTextColorSecondary,
                                        fontSize: 14)),
                                Text("\u{20B9}${value["price"]}",
                                    style: TextStyle(
                                        color: BHColorPrimary,
                                        fontSize: 15.w,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      15.height,
                      Container(
                        padding: EdgeInsets.all(8.w),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mode",
                              style: TextStyle(
                                  color: BHColorPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Payment Mode",
                                    style: TextStyle(
                                        color: BHAppTextColorSecondary,
                                        fontSize: 14)),
                                Text(value["mode"]=="online"?"Paid":"Cash on delivery",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 17.w,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      20.height,
                      OtpTextField(
                        numberOfFields: 4,
                        focusedBorderColor: BHColorPrimary,
                        enabledBorderColor: Colors.black12,
                        disabledBorderColor: Colors.black,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.w),
                        //set to true to show as box or false to show as dash
                        showFieldAsBox: true,
                        decoration: InputDecoration(
                          isDense:true,
                        ),
                        borderWidth: 1,
                        //runs when a code is typed in
                        fieldWidth: 45.w,
                        margin: EdgeInsets.only(right: 7.w),
                        keyboardType: TextInputType.number,
                        fillColor: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        onSubmit: (String verificationCode) {
                          // setState(() {
                          code  = verificationCode;
                          // });
                        }, // end onSubmit
                      ),
                      GestureDetector(
                        onTap: () async{
                          if(value["code"].toString()!=code){
                            Fluttertoast.showToast(msg: "Enter correct code");
                          }
                          else{
                            setState(() {
                              loading=true;
                            });
                            String user_bookID="";
                            await FirebaseFirestore.instance.collection("bookings").doc(widget.userId).collection("booking").where("booking_id",isEqualTo: widget.bookingID).get().then((snapshot) {
                              for(DocumentSnapshot doc in snapshot.docs){
                                user_bookID = doc.id;
                              }
                            });
                            print(user_bookID);
                            await FirebaseFirestore.instance.collection("bookings").doc(widget.userId).collection("booking").doc(user_bookID).update({
                              "status":"completed"
                            });
                            await FirebaseFirestore.instance.collection("salon_bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").doc(widget.id).update({
                                "status":"completed"
                            });
                            String owner_name ="";
                            String owner_image = "";
                            String owner_phone="";
                            String owner_address="";
                            await FirebaseFirestore.instance.collection("owners").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                      owner_name = value["salon_name"];
                                      owner_image=value["image"];
                                      owner_phone=value["phone"];
                                      owner_address=value["address"]+value["city"];
                            });
                            var check = await FirebaseFirestore.instance.collection("payments").doc(FirebaseAuth.instance.currentUser!.uid).get();
                            if(check.exists){
                              await FirebaseFirestore.instance.collection("payments").doc(FirebaseAuth.instance.currentUser!.uid).update(
                                 value["mode"]=="online"? {
                               "online":FieldValue.increment(value["price"])
                              }:{
                                   "offline":FieldValue.increment(value["price"])
                                 }
                              );
                            }
                            else{
                              await FirebaseFirestore.instance.collection("payments").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                "owner_id":FirebaseAuth.instance.currentUser!.uid,
                                "owner_name":owner_name,
                                "owner_image":owner_image,
                                "owner_phone":owner_phone,
                                "owner_address":owner_address,
                                "online":value["mode"]=="online"?value["price"]:0,
                                "offline":value["mode"]=="offline"?value["price"]:0,
                              });
                            }
                            await FirebaseFirestore.instance.collection("users").doc(widget.userId).update({
                              "rewards":FieldValue.increment(1),
                            });
                            setState(() {
                              loading=false;
                            });
                            Fluttertoast.showToast(msg: "Booking completed successfully");
                            Navigator.pop(context);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10.h),
                          padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 15.h),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Completed",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.w),),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }
      ),
    );
  }
}
