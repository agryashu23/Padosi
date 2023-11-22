import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/Admin_Bookings/edit_other_bookings.dart';

import '../../hairSalon/utils/BHColors.dart';
import '../../main/utils/AppWidget.dart';

class ShowOtherBookings extends StatefulWidget {
  const ShowOtherBookings({Key? key}) : super(key: key);

  @override
  State<ShowOtherBookings> createState() => _ShowOtherBookingsState();
}

class _ShowOtherBookingsState extends State<ShowOtherBookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Services Bookings",style: TextStyle(fontSize: 17.w),),
      ),
      body: FutureBuilder(
          future:FirebaseFirestore.instance.collection("other_bookings").get(),
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
                    return GestureDetector(
                      onTap: (){
                        value[index]["status"]=="pending"?EditOtherBookings(title:value[index]["title"],userId:value[index]["user_id"],
                            id:value[index].id,city:value[index]["city"]).launch(context):null;
                      },
                      child: Card(
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
                                          value[index]["image"], 50.h,
                                          width: 70.w, fit: BoxFit.cover),
                                    ),
                                    8.width,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 130.w,
                                          padding: EdgeInsets.only(left: 3.w),
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
                                              width: 220.w,
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
                                Divider(),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(value[index]["user_name"],
                                          style: TextStyle(
                                              fontSize: 15.w, color: Colors.red,fontWeight: FontWeight.bold)),
                                      10.width,
                                      Text(value[index]["user_phone"],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                              fontSize: 15.w)),
                                    ],
                                  ),
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
                                          Text(value[index]["contact"],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
      ),
    );
  }
}
