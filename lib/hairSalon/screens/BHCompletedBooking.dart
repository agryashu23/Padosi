import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon/hairSalon/screens/BHCompletedBooking.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/BHShowBooking.dart';

import '../../main/notification/notification_service.dart';
import '../../main/utils/AppWidget.dart';
import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/BHImages.dart';
import 'load_widget.dart';

class BHCompletedBooking extends StatefulWidget {
  const BHCompletedBooking({Key? key}) : super(key: key);

  @override
  State<BHCompletedBooking> createState() => _BHCompletedBookingState();
}

class _BHCompletedBookingState extends State<BHCompletedBooking> {
  bool isSwitched = false;
  bool loading=false;
  DateTime? date;
  DateTime now = DateTime.now();


  @override
  void initState() {
    super.initState();
    date = DateTime.now();

  }
  Widget SalonAppointmentWidget() {
    return FutureBuilder(
        future:FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").where("status",isEqualTo:"completed").get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          else if(!snapshot.hasData){
            return Center(child: Text("Make a Appointment",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold),),);
          }
          else if(snapshot.data!.docs.isEmpty){
            return Center(child: Text("Make an Appointment",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
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
                  return Card(
                    elevation: 4,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  child: commonCacheImageWidget(
                                      value[index]["owner_image"], 60.h,
                                      width: 90.w, fit: BoxFit.cover),
                                ),
                                8.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120.w,
                                      child: Text(
                                        value[index]["owner_name"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: BHAppTextColorPrimary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    8.height,
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 14,
                                            color: BHAppTextColorSecondary),
                                        Container(
                                          width: 130.w,
                                          child: Text(value[index]["owner_address"]+","+value[index]["owner_city"],
                                              style: TextStyle(
                                                  fontSize: 12, color: BHGreyColor)),
                                        ),
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
                            ...List.generate(value[index]["name"].length, (idx){
                              return Text(value[index]["name"][idx],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400));
                            }),
                            8.height,
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
                                          color: Colors.green, fontSize: 14,fontWeight: FontWeight.bold)),
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
                    ),
                  );
                },
              ),
            );
          }
        }
    );
  }

  Widget CompletedOtherAppointmentWidget() {
    return loading?BHLoading():FutureBuilder(
        future:FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("other").where("status",isEqualTo: "completed").get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return Center(child: Text("Make an Appointment",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold),),);
          }
          else {
            var value = snapshot.data!.docs;
            return Container(
              color: BHGreyColor.withOpacity(0.1),
              child: ListView.builder(
                itemCount: value.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 7.h),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  child: commonCacheImageWidget(
                                      value[index]["image"], 40.h,
                                      width: 70.w, fit: BoxFit.cover),
                                ),
                                8.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120.w,
                                      child: Text(
                                        value[index]["title"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: BHAppTextColorPrimary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    8.height,
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 14,
                                            color: BHAppTextColorSecondary),
                                        Container(
                                          width: 130.w,
                                          child: Text(value[index]["address"]+","+value[index]["city"],
                                              style: TextStyle(
                                                  fontSize: 12, color: BHGreyColor)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Divider(),
                            // Container(
                            //   width: 300.w,
                            //   child: Text(value[index]["desc"],
                            //       style: TextStyle(
                            //           fontSize: 12, color: BHGreyColor)),
                            // ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(value[index]["status"].toUpperCase(),
                                      style:
                                      TextStyle(
                                          color: value[index]["status"]=="pending"?BHColorPrimary:Colors.green,
                                          fontSize: 14,fontWeight: FontWeight.bold)),
                                ),
                                Text(value[index]["date"],
                                    style: TextStyle(
                                        color: BHAppTextColorPrimary,
                                        fontSize: 14)),
                              ],
                            ),
                            5.height,
                          ],
                        ),
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
        appBar: AppBar(
          backgroundColor: BHColorPrimary,
          title: Text("Completed Bookings",style: TextStyle(fontSize: 17.w),),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: BHAppTextColorPrimary,
            indicatorColor: Colors.blue,
            onTap: (index) {},
            tabs: [
              Tab(child: Text("Salon Bookings", style: TextStyle(fontSize: 14))),
              Tab(child: Text("Other Bookings", style: TextStyle(fontSize: 14))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SalonAppointmentWidget(),
            // CancelAppointmentWidget(),
            CompletedOtherAppointmentWidget(),
          ],
        ),
      ),
    );
  }
}

