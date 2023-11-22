import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:salon/owner/owner_showAppointment.dart';

import '../hairSalon/utils/BHColors.dart';
import '../hairSalon/utils/BHConstants.dart';
import '../hairSalon/utils/BHImages.dart';
import '../main/utils/AppWidget.dart';

class OwnerAppointmentScreen extends StatefulWidget {
  static String tag = '/AppointmentBottomNavigationBarScreen';

  @override
  OwnerAppointmentScreenState createState() => OwnerAppointmentScreenState();
}

class OwnerAppointmentScreenState extends State<OwnerAppointmentScreen>
    with SingleTickerProviderStateMixin {
  bool isSwitched = false;

  DateTime? date;

  String token = '';
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    // getToken();
    // configure();
  }


  Widget ongoingAppointmentWidget() {
    return FutureBuilder(
        future:FirebaseFirestore.instance.collection("salon_bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").where("status",isEqualTo:"pending").get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return BHLoading();
          }
          else if(!snapshot.hasData){
            return Center(child: Text("No Upcoming Bookings",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold),),);
          }
          else if(snapshot.data!.docs.isEmpty){
            return Center(child: Text("No Upcoming Bookings",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
          }
          else {
            var value = snapshot.data!.docs;
            return Container(
                color: BHGreyColor.withOpacity(0.1),
                child: ListView.builder(
                    itemCount: value.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5.w),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          print(token);
                          OwnerShowAppointment(id:value[index].id,bookingID:value[index]["booking_id"],userId:value[index]["user_id"]).launch(context);

                        },
                        child: Card(
                          elevation: 4,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: whiteColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          value[index]["user_image"]==""?Container(width: 90.w,):ClipRRect(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                            child: commonCacheImageWidget(
                                                value[index]["user_image"], 60.h,
                                                width: 90.w, fit: BoxFit.cover),
                                          ),
                                          10.width,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 180.w,
                                                    child: Text(value[index]["user_name"]??"",
                                                        style: TextStyle(
                                                            fontSize: 14.w,
                                                            color: BHAppTextColorPrimary,
                                                            fontWeight: FontWeight.bold)),
                                                  ),
                                                  Icon(Icons.call_rounded,color: Colors.blue,)
                                                ],
                                              ),
                                              5.height,
                                              Text(
                                                "Appointment ID #${value[index]["booking_id"]}",
                                                style: TextStyle(
                                                    fontSize: 14.w,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400 ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(),


                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ...List.generate(value[index]["name"].length, (idx){
                                                  return Text(value[index]["name"][idx],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400));
                                                }),
                                              ],
                                            ),

                                          ]),
                                      Divider(),
                                      5.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(value[index]["booking_time"].toDate()),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: BHAppTextColorSecondary)),
                                          Text(DateFormat.jm().format(value[index]["booking_time"].toDate()).toString(),
                                              style: TextStyle(
                                                  color: BHColorPrimary,
                                                  fontSize: 15.w,fontWeight: FontWeight.bold)),
                                          // Image.asset(BHBarCodeImg, height: 50, width: 120),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
          }
        }
    );
  }

  Widget historyAppointmentWidget() {
    return FutureBuilder(
        future:FirebaseFirestore.instance.collection("salon_bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").where("status",isEqualTo:"completed").get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          else if(!snapshot.hasData){
            return Center(child: Text("No Bookings Completed",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold),),);
          }
          else if(snapshot.data!.docs.isEmpty){
            return Center(child: Text("No Bookings Completed",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
          }
          else {
            var value = snapshot.data!.docs;
            return Container(
              color: BHGreyColor.withOpacity(0.1),
              child: ListView.builder(
                itemCount: value.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(5.w),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8.w),
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
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              value[index]["user_image"]==""?Container(width: 90.w,):ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                                child: commonCacheImageWidget(
                                    value[index]["user_image"], 60.h,
                                    width: 90.w, fit: BoxFit.cover),
                              ),
                              8.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120.w,
                                    child: Text(
                                      value[index]["user_name"],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: BHAppTextColorPrimary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  5.height,
                                  Text(
                                    "Appointment ID #${value[index]["booking_id"]}",
                                    style: TextStyle(
                                        fontSize: 14.w,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400 ),
                                  ),
                                  8.height,
                                ],
                              ),
                            ],
                          ),
                          8.height,
                          ...List.generate(value[index]["name"].length, (idx){
                            return Text(value[index]["name"][idx],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400));
                          }),
                          5.height,
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text('Total',
                                    style:
                                    TextStyle(
                                        color: BHColorPrimary, fontSize: 14,fontWeight: FontWeight.bold)),
                              ),
                              Text("\u{20B9}${value[index]["price"]}",
                                  style: TextStyle(
                                      color: BHAppTextColorPrimary,
                                      fontSize: 14,fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text('Completed',
                                    style:
                                    TextStyle(
                                        color: BHColorPrimary, fontSize: 14,fontWeight: FontWeight.bold)),
                              ),
                              Text(DateFormat('yyyy-MM-dd')
                                  .format(value[index]["booking_time"].toDate()),
                                  style: TextStyle(
                                      color: BHAppTextColorPrimary,
                                      fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: TabBar(
          labelColor: BHColorPrimary,
          unselectedLabelColor: BHAppTextColorPrimary,
          indicatorColor: BHColorPrimary,
          onTap: (index) {},
          tabs: [
            Tab(child: Text(BHTabOngoing, style: TextStyle(fontSize: 14))),
            Tab(child: Text(BHTabHistory, style: TextStyle(fontSize: 14))),
          ],
        ),
        body: TabBarView(
          children: [
            ongoingAppointmentWidget(),
            historyAppointmentWidget(),
          ],
        ),
      ),
    );
  }
}
