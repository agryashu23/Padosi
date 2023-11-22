import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../../main/utils/AppWidget.dart';
import '../utils/BHConstants.dart';
import 'package:intl/intl.dart';

import 'BHDashedBoardScreen.dart';

class BHShowBooking extends StatefulWidget {
  const BHShowBooking({Key? key ,required this.id, required this.bookingID}) : super(key: key);
  final String id;
  final String bookingID;

  @override
  State<BHShowBooking> createState() => _BHShowBookingState();
}

class _BHShowBookingState extends State<BHShowBooking> {
  bool loading =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment No. #${widget.bookingID}"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: FutureBuilder(
          future:FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").doc(widget.id).get(),
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
                          ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                            child: commonCacheImageWidget(
                                value["owner_image"], 60.h,
                                width: 80.w, fit: BoxFit.cover),
                          ),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [
                              Container(
                                width: 130.w,
                                child: Text(value["owner_name"],
                                    style: TextStyle(
                                        fontSize: 14.w,
                                        color: BHAppTextColorPrimary,
                                        fontWeight: FontWeight.bold)),
                              ),
                              8.height,
                              Container(width: 130.w,
                                child: Text(
                                    value["owner_address"]+","+value["owner_city"],
                                    style: TextStyle(
                                        fontSize: 13.w,
                                        color: BHGreyColor)),
                              ),
                              5.height,
                              Container(
                                width: 140.w,
                                child: Text(
                                  value["owner_phone"],
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
                      25.height,
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
                      GestureDetector(
                        onTap: ()async{
                           await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return loading?BHLoading():AlertDialog(
                                  contentTextStyle: TextStyle(color: BHAppTextColorSecondary),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                                  actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                  title: Text("Cancel Appointment", style: TextStyle(fontSize: 16, color: BHAppTextColorPrimary)),
                                  content: Text("Do you really want to cancel appointment?", style: TextStyle(fontSize: 14, color: BHAppTextColorSecondary)),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(BHBtnYes, style: TextStyle(color: Colors.blue, fontSize: 14)),
                                      onPressed: () async {
                                        setState(() {
                                          loading=true;
                                        });
                                        await FirebaseFirestore.instance.collection("cancelled").add({
                                          "owner_id":value["owner_id"],
                                          "user_id":FirebaseAuth.instance.currentUser!.uid ,
                                          "booking_id":value["booking_id"],
                                          "booking_time":value["booking_time"],
                                          "owner_name":value["owner_name"],
                                          "price":value["price"],
                                          "name":value["name"],
                                          "owner_address":value["owner_address"],
                                          "owner_city":value["owner_city"],
                                          "mode":value["mode"],
                                        });
                                        await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid)
                                            .collection("booking").where("booking_id",isEqualTo:value["booking_id"]).get().then((snapshot){
                                          for(DocumentSnapshot doc in snapshot.docs){
                                            doc.reference.delete();
                                          }
                                        });
                                        await FirebaseFirestore.instance.collection("salon_bookings").doc(value["owner_id"])
                                            .collection("booking").where("booking_id",isEqualTo:value["booking_id"]).get().then((snapshot){
                                          for(DocumentSnapshot doc in snapshot.docs){
                                            doc.reference.delete();
                                          }
                                        });
                                        setState(() {
                                          loading=false;
                                        });
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(msg: "Appointment Cancelled");
                                      },
                                    ),
                                    TextButton(
                                      child: Text(BHBtnNo, style: TextStyle(color: Colors.blue, fontSize: 14)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          // setState(() {
                          // });
                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                               builder: (context) => BHDashedBoardScreen()), (route) => false);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 70.h),
                          padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 15.h),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Cancel",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.w),),
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
