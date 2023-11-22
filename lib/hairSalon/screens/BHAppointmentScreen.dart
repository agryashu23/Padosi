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

class BHAppointmentScreen extends StatefulWidget {
  static String tag = '/AppointmentBottomNavigationBarScreen';

  @override
  BHAppointmentScreenState createState() => BHAppointmentScreenState();
}

class BHAppointmentScreenState extends State<BHAppointmentScreen>
    with SingleTickerProviderStateMixin {
  bool isSwitched = false;
  bool loading=false;
  DateTime? date;
  DateTime now = DateTime.now();


  @override
  void initState() {
    super.initState();
    date = DateTime.now();

  }

  Widget ongoingSalonAppointmentWidget() {
    return loading?BHLoading():StreamBuilder(
      stream:FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").where("status",isEqualTo:"pending").snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child:CircularProgressIndicator());
        }
        else if(!snapshot.hasData){
          print("ans");
          return Center(child: Text("Make an Appointment",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
        }
        else if(snapshot.data!.docs.isEmpty){
          return Center(child: Text("Make an Appointment",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
        }
        else{
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
                        BHShowBooking(id:value[index].id,bookingID:value[index]["booking_id"].toString()).launch(context);
                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5.w),
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
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                            child: commonCacheImageWidget(
                                                value[index]["owner_image"], 60.h,
                                                width: 80.w, fit: BoxFit.cover),
                                          ),
                                          10.width,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                width: 130.w,
                                                child: Text(value[index]["owner_name"],
                                                    style: TextStyle(
                                                        fontSize: 14.w,
                                                        color: BHAppTextColorPrimary,
                                                        fontWeight: FontWeight.bold)),
                                              ),
                                              8.height,
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on,
                                                      size: 14.w,
                                                      color: BHAppTextColorSecondary),
                                                  Container(width: 130.w,
                                                    child: Text(
                                                        value[index]["owner_address"]+","+value[index]["owner_city"],
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: BHGreyColor)),
                                                  ),
                                                ],
                                              ),
                                              5.height,
                                              Container(
                                                width: 140.w,
                                                child: Text(
                                                  "Appointment ID #${value[index]["booking_id"]}",
                                                  style: TextStyle(
                                                      fontSize: 13.w,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w400 ),
                                                ),
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
                                            Text(DateFormat.jm().format(value[index]["booking_time"].toDate()).toString(),
                                                style: TextStyle(
                                                    color: BHColorPrimary,
                                                    fontSize: 15.w,fontWeight: FontWeight.bold)),
                                          ]),
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
                                          // Image.asset(BHBarCodeImg, height: 50, width: 120),
                                        ],
                                      ),
                                      now.compareTo(value[index]["booking_time"].toDate().subtract(const Duration(minutes: 30)))<0?Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text('Remind me 30 min in advance',
                                              style: TextStyle(
                                                  fontSize: 13.w,
                                                  color: BHAppTextColorPrimary)),
                                          Transform.scale(
                                            scale: 0.7,
                                            child: CupertinoSwitch(
                                              value: value[index]["switch"],
                                              activeColor: BHColorPrimary,
                                              onChanged: (values)async {
                                                DateTime date = value[index]["booking_time"].toDate();
                                                date = date.subtract(Duration(minutes: 30));
                                                  await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("booking").doc(value[index].id).update({
                                                    "switch":values,
                                                  });
                                                  if(value[index]["switch"]){
                                                    print(date.toString());
                                                    NotificationService().scheduleNotification(
                                                        title: 'Scheduled Notification',
                                                        body: "You have booking at ${date.hour}:${date.minute} ",
                                                        // payLoad: "done",
                                                        scheduledNotificationDateTime: date);
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ):Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }));

        }
      }
    );
  }

  Widget OtherAppointmentWidget() {

    showAlertDialog(BuildContext context, String id) {
      Widget cancelButton = TextButton(
        child: Text("No"),
        onPressed:  () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("Yes"),
        onPressed:  () async{
          await FirebaseFirestore.instance.collection("other_bookings").doc(id).delete();
          await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("other").doc(id).update({
            "status":"completed",
            "alloted":false,
          });
          Fluttertoast.showToast(msg: "Booking completed");
          Navigator.of(context).pop();
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Booking Completed"),
        content: Text("Are you sure booking is completed?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    return StreamBuilder(
        stream:FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("other").where("alloted",isEqualTo: true).snapshots(),
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
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
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
                      padding: EdgeInsets.only(top: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  child: commonCacheImageWidget(
                                      value[index]["image"], 50.h,
                                      width: 70.w, fit: BoxFit.fitHeight),
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
                                value[index]["status"]=="alloted"?GestureDetector(
                                  onTap: (){
                                    showAlertDialog(context,value[index].id);
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade400,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                                      child: Text("Complete",style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),
                          // Divider(),
                          // Container(
                          //   width: 300.w,
                          //   padding:EdgeInsets.symmetric(horizontal: 8.w),
                          //   child: Text(value[index]["desc"],
                          //       style: TextStyle(
                          //           fontSize: 12, color: BHGreyColor)),
                          // ),
                          Divider(),
                          Padding(
                            padding:EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(value[index]["status"].toUpperCase(),
                                    style:
                                    TextStyle(
                                        color: value[index]["status"]=="pending"?BHColorPrimary:Colors.green,
                                        fontSize: 14,fontWeight: FontWeight.bold)),
                                Text(value[index]["date"],
                                    style: TextStyle(
                                        color: BHAppTextColorPrimary,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                          Divider(),
                          value[index]["officer"]==""?Container():Container(
                            padding:EdgeInsets.symmetric(horizontal: 8.w),
                            color: Colors.green.shade100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(value[index]["officer_image"]),
                                    radius: 30),
                                Column(
                                  children: [
                                    Text(value[index]["officer"],
                                        style:
                                        TextStyle(
                                            color: BHColorPrimary, fontSize: 14,fontWeight: FontWeight.bold)),
                                    10.height,
                                    GestureDetector(
                                      onTap: ()async{
                                        await UrlLauncher.launch("tel:${value[index]["contact"]}");
                                      },
                                      child: Text(value[index]["contact"],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                              fontSize: 14)),
                                    ),
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
            Tab(child: Text("Salon Bookings", style: TextStyle(fontSize: 14))),
            Tab(child: Text("Other Bookings", style: TextStyle(fontSize: 14))),
          ],
        ),
        body: TabBarView(
          children: [
            ongoingSalonAppointmentWidget(),
            OtherAppointmentWidget(),
          ],
        ),
      ),
    );
  }
}
