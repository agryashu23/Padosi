import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../main/utils/AppWidget.dart';
import 'edit_payment.dart';

class AdminPayment extends StatefulWidget {
  const AdminPayment({Key? key}) : super(key: key);

  @override
  State<AdminPayment> createState() => _AdminPaymentState();
}

class _AdminPaymentState extends State<AdminPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Payments"),
          centerTitle: true,
          backgroundColor: BHColorPrimary,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("payments").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty ) {
              return Center(
                child: Text(
                  "No data",
                  style: TextStyle(
                      fontSize: 18.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              );
            } else {
              var value = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: value.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5.w),
                  itemBuilder: (context, index) {
                    return  Card(
                      elevation: 4,
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
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      child: commonCacheImageWidget(
                                          value[index]["owner_image"], 60.h,
                                          width: 90.w, fit: BoxFit.cover),
                                    ),
                                    10.width,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                          width: 180.w,
                                          child: Text(value[index]["owner_name"],
                                              style: TextStyle(
                                                  fontSize: 14.w,
                                                  color: BHAppTextColorPrimary,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        5.height,
                                        Row(
                                          children: [
                                            Text(
                                              value[index]["owner_phone"],
                                              style: TextStyle(
                                                  fontSize: 14.w,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400 ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                EditPayment(online:value[index]["online"],offline:value[index]["offline"],phone:value[index]["owner_phone"],id:value[index].id).launch(context);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(left: 50.w),
                                                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 7.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                ),
                                                child: Text("Edit",style: TextStyle(color: Colors.white,fontSize: 14.w),),
                                              ),
                                            )
                                          ],
                                        ),
                                        5.height,
                                        Container(
                                          width: 200.w,
                                          child: Text(
                                            value[index]["owner_address"],
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

                                Divider(),
                                5.height,
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                          "Online-",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: BHAppTextColorSecondary)),
                                      Text("\u{20B9}${value[index]["online"]}",
                                          style: TextStyle(
                                              color: BHColorPrimary,
                                              fontSize: 15.w,fontWeight: FontWeight.bold)),
                                      VerticalDivider(color: Colors.black,width: 1.0,),
                                      Text(
                                          "Offline-",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: BHAppTextColorSecondary)),
                                      Text("\u{20B9}${value[index]["offline"]}",
                                          style: TextStyle(
                                              color: BHColorPrimary,
                                              fontSize: 15.w,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          },
        ));
  }
}
