import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/BHRefund.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';
import 'package:intl/intl.dart';

import '../../main/utils/AppWidget.dart';

class BHCancelledScreen extends StatefulWidget {
  const BHCancelledScreen({Key? key}) : super(key: key);

  @override
  State<BHCancelledScreen> createState() => _BHCancelledScreenState();
}

class _BHCancelledScreenState extends State<BHCancelledScreen> {
  bool isSwitched = false;
  bool loading=false;
  DateTime? date;
  DateTime now = DateTime.now();


  @override
  void initState() {
    super.initState();
    date = DateTime.now();

  }
  Widget CancelOtherAppointmentWidget() {
    return FutureBuilder(
        future:FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("other").where("status",isEqualTo: "cancel").get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return Center(child: Text("Yay, No cancelled bookings",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold),),);
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
                                          color: Colors.red,
                                          fontSize: 14,fontWeight: FontWeight.bold)),
                                ),
                                Text(value[index]["date"],
                                    style: TextStyle(
                                        color: BHAppTextColorPrimary,
                                        fontSize: 14)),
                              ],
                            ),
                            Divider(),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text("Sorry, No workers available at your location.",
                                    style:
                                    TextStyle(
                                        color: BHColorPrimary, fontSize: 14,fontWeight: FontWeight.w500)),
                              ),
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

  Widget CancelAppointmentWidget(){
        return FutureBuilder(
          future: FirebaseFirestore.instance.collection("cancelled").where("user_id",isEqualTo:FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return BHLoading();
            }
            else if(!snapshot.hasData){
              print("ans");
              return Center(child: Text("Yay, No Cancelled Bookings",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
            }
            else if(snapshot.data!.docs.isEmpty){
              return Center(child: Text("Yay, No Cancelled Bookings",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold,color: Colors.black),),);
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
                        return Card(
                          elevation: 4,
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children:[
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: 5.w),
                                                  width: 130.w,
                                                  child: Text(value[index]["owner_name"],
                                                      style: TextStyle(
                                                          fontSize: 15.w,
                                                          color: BHAppTextColorPrimary,
                                                          fontWeight: FontWeight.bold)),
                                                ),
                                                4.height,
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on,
                                                        size: 14.w,
                                                        color: BHAppTextColorSecondary),
                                                    1.width,
                                                    Container(width: 130.w,
                                                      child: Text(
                                                          value[index]["owner_address"]+","+value[index]["owner_city"],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: BHGreyColor)),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                            Container(
                                              width: 140.w,
                                              child: Text(
                                                "Appointment ID #${value[index]["booking_id"]}",
                                                style: TextStyle(
                                                    fontSize: 14.w,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600 ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left:5.w),
                                                child: Column(
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
                                              ),
                                              Text(DateFormat.jm().format(value[index]["booking_time"].toDate()).toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.w,fontWeight: FontWeight.bold)),
                                            ]),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 4),
                                              child: Text('Total',
                                                  style:
                                                  TextStyle(
                                                      color: Colors.black, fontSize: 15.w,fontWeight: FontWeight.bold)),
                                            ),
                                            Text("\u{20B9}${value[index]["price"]}",
                                                style: TextStyle(
                                                    color: BHAppTextColorPrimary,
                                                    fontSize: 15.w,fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        Divider(),
                                        2.height,
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              // value[index]["mode"]=="online"?GestureDetector(
                                              //   onTap:()async{
                                              //     String user_name="";
                                              //     await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                              //       user_name = value["name"];
                                              //     });
                                              //     BHRefund(name: user_name,book_id:value[index]["booking_id"],price:value[index]["price"],id:value[index].id).launch(context);
                                              //   },
                                              //   child: Card(
                                              //     elevation: 5.0,
                                              //     child: Container(
                                              //       padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 7.h),
                                              //       decoration: BoxDecoration(
                                              //         color: Colors.green,
                                              //       ),
                                              //       child: Text("Get Refund",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                              //     ),
                                              //   ),
                                              // ):value[index]["mode"]=="refund"?Padding(
                                              //   padding: EdgeInsets.only(left: 4),
                                              //   child: Text('Refund Processed',
                                              //       style:
                                              //       TextStyle(
                                              //           color: Colors.red, fontSize: 16.w,fontWeight: FontWeight.bold)),
                                              // ):value[index]["mode"]=="completed"?Padding(
                                              //   padding: EdgeInsets.only(left: 4),
                                              //   child: Text('Refunded',
                                              //       style:
                                              //       TextStyle(
                                              //           color: Colors.red, fontSize: 16.w,fontWeight: FontWeight.bold)),
                                              // ):
                                              Padding(
                                                padding: EdgeInsets.only(left: 4),
                                                child: Text('Cancelled',
                                                    style:
                                                    TextStyle(
                                                        color: Colors.red, fontSize: 16.w,fontWeight: FontWeight.bold)),
                                              ),
                                              Text(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(value[index]["booking_time"].toDate()),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: BHAppTextColorSecondary)),
                                              // Image.asset(BHBarCodeImg, height: 50, width: 120),
                                            ],
                                          ),
                                        ),
                                        10.height,
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

          },
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
          title: Text("Cancelled Bookings",style: TextStyle(fontSize: 17.w),),
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
            CancelAppointmentWidget(),
            CancelOtherAppointmentWidget(),
          ],
        ),
      ),
    );
  }
}

