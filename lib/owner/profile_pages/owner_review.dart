import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';

import '../../hairSalon/utils/BHColors.dart';
import '../../hairSalon/utils/BHImages.dart';
import '../../hairSalon/utils/widget_constant.dart';

class OwnerReview extends StatefulWidget {
  static String tag = '/OwnerReview';

  @override
  State<OwnerReview> createState() => _OwnerReviewState();
}

class _OwnerReviewState extends State<OwnerReview> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Reviews"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("reviews").doc(FirebaseAuth.instance.currentUser!.uid).collection("review").get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:BHLoading());
          }
          else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return Center(child: Text("No Reviews",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold),),);
          }
          else {
            var value = snapshot.data!.docs;
            return ListView.builder(
                itemCount: value.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: 12.h, left: 2.w, right: 2.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                              backgroundImage:
                              NetworkImage(value[index]["user_image"]),
                              radius: 35),
                          title: Text(value[index]["user_name"]),
                          trailing: Text(DateFormat('yyyy-MM-dd')
                              .format(DateTime.now()),),
                          subtitle: RatingBar.builder(
                            initialRating: reviews,
                            minRating: 1,
                            ignoreGestures: true,
                            itemSize: 18.w,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                            EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) =>
                                Icon(
                                  Icons.star,
                                  color: BHColorPrimary,
                                ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5.w, right: 5.w, bottom: 3.h),
                          child: Text(
                              value[index]["message"]),
                        ),
                      ],
                    ),
                  );
                });
          }
        }
      ),
    );
  }
  double reviews=0.0;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("owners").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        reviews = value["reviews"];
    });
  }
}
