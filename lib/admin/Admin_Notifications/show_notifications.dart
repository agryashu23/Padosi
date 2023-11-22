import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../hairSalon/utils/BHColors.dart';

class ShowNotifications extends StatefulWidget {
  const ShowNotifications({Key? key}) : super(key: key);

  @override
  State<ShowNotifications> createState() => _ShowNotificationsState();
}

class _ShowNotificationsState extends State<ShowNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Show Notifications"),
        backgroundColor: BHColorPrimary,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("notifications").get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var value = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  value[index]["title"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: BHAppTextColorPrimary,
                                      fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: ()async{
                                    await FirebaseFirestore.instance.collection("notifications").doc(value[index].id).delete();
                                    setState(() {
                                    });
                                  },
                                  child: Container(
                                    width: 70.w,
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: BHColorPrimary,
                                          decoration: TextDecoration.underline,
                                          fontSize: 16.w),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          5.height,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Text(
                              value[index]["subtitle"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 13.w),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
            else{
              return Center(child: Text("No Feed"),);
            }
          }
      ),
    );
  }
}