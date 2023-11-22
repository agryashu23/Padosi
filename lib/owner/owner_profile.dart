import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/main/contact_us.dart';
import 'package:salon/owner/profile_pages/edit_account.dart';
import 'package:salon/owner/profile_pages/owner_gallery.dart';
import 'package:salon/owner/profile_pages/owner_packages.dart';
import 'package:salon/owner/profile_pages/owner_payDetails.dart';
import 'package:salon/owner/profile_pages/owner_review.dart';
import 'package:salon/owner/profile_pages/owner_services.dart';
import 'package:salon/owner/profile_pages/owner_slots.dart';

import '../hairSalon/screens/BHAccountInformationScreen.dart';
import '../hairSalon/screens/BHLoginScreen.dart';
import '../hairSalon/screens/load_widget.dart';
import '../hairSalon/utils/BHColors.dart';
import '../hairSalon/utils/BHConstants.dart';
import '../hairSalon/utils/BHImages.dart';
import '../hairSalon/utils/dialog.dart';
import '../hairSalon/utils/widget_constant.dart';
import '../main/utils/AppWidget.dart';

class OwnerProfileScreen extends StatefulWidget {
  static String tag = '/OwnerProfileScreen';


  @override
  OwnerProfileScreenState createState() => OwnerProfileScreenState();
}

class OwnerProfileScreenState extends State<OwnerProfileScreen> {
  bool status = false;
  String urlImage="";
  String name="";
  @override
  Widget build(BuildContext context) {
    // Future<void> _showDialog() async {
    //   return showDialog<void>(
    //       context: context,
    //       barrierDismissible: true,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           contentTextStyle: TextStyle(color: BHAppTextColorSecondary),
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(4))),
    //           actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
    //           title: Text(BHTxtLogoutDialog,
    //               style: TextStyle(fontSize: 16, color: BHAppTextColorPrimary)),
    //           content: Text(BHTxtLogoutMsg,
    //               style:
    //                   TextStyle(fontSize: 14, color: BHAppTextColorSecondary)),
    //           actions: <Widget>[
    //             TextButton(
    //               child: Text(BHBtnYes,
    //                   style: TextStyle(color: Colors.blue, fontSize: 14)),
    //               onPressed: () async{
    //                 SharedPreferences prefs = await SharedPreferences.getInstance();
    //                 prefs.setBool('owner', false);
    //                 prefs.setBool('step', false);
    //                 FirebaseAuth.instance.signOut();
    //                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BHLoginScreen()), (route) => false);
    //               },
    //             ),
    //             TextButton(
    //               child: Text(BHBtnNo,
    //                   style: TextStyle(color: Colors.blue, fontSize: 14)),
    //               onPressed: () {},
    //             ),
    //           ],
    //         );
    //       });
    // }

    return Scaffold(
      backgroundColor: Colors.white70,
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('owners').doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done ) {
        var value = snapshot.data!;
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: false,
              pinned: true,
              floating: false,
              leading: Container(),
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                title: Container(
                  padding: EdgeInsets.only(left: 12.w),
                  width: context.width(),
                  child: Text("Your Profile",
                      style: TextStyle(
                          color: BHAppTextColorPrimary,
                          fontSize: 16.w,
                          fontWeight: FontWeight.bold
                      ) //TextStyle
                  ),
                ), //Text
                background: Stack(
                  children: [
                    commonCacheImageWidget(
                        BHWalkThroughImg3, context.height() * 0.22,
                        width: context.width(), fit: BoxFit.fitWidth),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin:
                          EdgeInsets.only(top: context.height() * 0.155),
                          child: CircleAvatar(
                            backgroundColor: BHColorPrimary,
                            radius: 49,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 47,
                                child:
                                CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(value["image"]),
                                    radius: 45)
                            ),
                          ),
                        ),
                        6.height,
                        Text(value["salon_name"],
                            style: TextStyle(
                                color: BHAppTextColorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.w)),
                        4.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('(${value["reviews"]})',
                                style: TextStyle(
                                    color: BHGreyColor, fontSize: 12.w)),
                            RatingBar.builder(
                              initialRating:value["reviews"],
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ), //Images.network
              ),
              //FlexibleSpaceBar
              expandedHeight: context.height() * 0.42,
              backgroundColor: Colors.grey.shade100,
            ), //SliverAppBar
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    Card(
                      margin: EdgeInsets.only(
                          top: 10.h, left: 10.w, right: 10.w),
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w,
                            vertical: 10.h),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  // BHAccountInformationScreen().launch(context);
                                  OwnerEditAccount().launch(context);
                                },
                                child: ProfileOwner(
                                    Icons.person, BHTxtAccountInformation)
                            ),
                            20.height,
                            GestureDetector(
                                onTap: () {
                                  OwnerGallery().launch(context);
                                },
                                child: ProfileOwner(Icons.photo, "Gallery")
                            ),
                            20.height,
                            GestureDetector(
                                onTap: () {
                                  OwnerReview().launch(context);
                                  // BHAccountInformationScreen().launch(context);
                                },
                                child: ProfileOwner(
                                    Icons.reviews_outlined, "Review")
                            ),
                            20.height,
                            GestureDetector(
                                onTap: () {
                                  // BHAccountInformationScreen().launch(context);
                                  OwnerTimeSlots().launch(context);
                                },
                                child: ProfileOwner(
                                    Icons.access_time_outlined, "Slots")
                            ),
                            20.height,
                            GestureDetector(
                                onTap: () {
                                  OwnerServices().launch(context);
                                  // BHAccountInformationScreen().launch(context);
                                },
                                child: ProfileOwner(
                                    Icons.design_services_outlined, "Services")
                            ),
                            20.height,
                            GestureDetector(
                                onTap: () {
                                  OwnerPackages().launch(context);

                                  // BHAccountInformationScreen().launch(context);
                                },
                                child: ProfileOwner(Icons.list_alt, "Packages")
                            ),
                            20.height,
                            GestureDetector(
                                onTap: () {
                                 ContactUs().launch(context);

                                },
                                child: ProfileOwner(Icons.phone, "Contact Us")
                            ),
                            20.height,
                            GestureDetector(
                                onTap: () {
                                  // BHAccountInformationScreen().launch(context);

                                },
                                child: ProfileOwner(Icons.privacy_tip_outlined,
                                    "Privacy Policy")
                            ),
                            20.height,
                            GestureDetector(
                                onTap: () {
                                 // OwnerPayment().launch(context);
                                  OwnerPayDetails().launch(context);
                                },
                                child: ProfileOwner(Icons.monetization_on,
                                    "Payment Details")
                            ),
                            20.height,
                            GestureDetector(
                                onTap: (){
                                  ShowDialog1(context);
                                },
                                child: ProfileOwner(Icons.logout, "Logout")
                            ),
                            20.height,


                          ],
                        ),
                      ),
                    ), //ListTile
                childCount: 1,
              ), //SliverChildBuildDelegate
            ) //SliverList
          ],

        );
      }
      else{
        return BHLoading();
      }
        }
      ),
    );
  }
}
