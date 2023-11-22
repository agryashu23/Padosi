import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/BHPrivacy.dart';
import 'package:salon/main/contact_us.dart';
import 'package:salon/owner/forms/loading.dart';
import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/BHImages.dart';
import '../utils/dialog.dart';
import 'BHAccountInformationScreen.dart';
import 'BHCancelledScreen.dart';
import 'BHCompletedBooking.dart';
import 'load_widget.dart';

class BHProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  BHProfileScreenState createState() => BHProfileScreenState();
}

class BHProfileScreenState extends State<BHProfileScreen> {
  String name="";
  String email="";
  String urlImage="";
  @override
  Widget build(BuildContext context) {
    // Future<void> _showDialog() async {
    //   return showDialog<void>(
    //       context: context,
    //       barrierDismissible: true,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           contentTextStyle: TextStyle(color: BHAppTextColorSecondary),
    //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
    //           actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
    //           title: Text(BHTxtLogoutDialog, style: TextStyle(fontSize: 16, color: BHAppTextColorPrimary)),
    //           content: Text(BHTxtLogoutMsg, style: TextStyle(fontSize: 14, color: BHAppTextColorSecondary)),
    //           actions: <Widget>[
    //             TextButton(
    //               child: Text(BHBtnYes, style: TextStyle(color: Colors.blue, fontSize: 14)),
    //               onPressed: () async {
    //                 finish(context);
    //                 FirebaseAuth.instance.signOut();
    //                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BHLoginScreen()), (route) => false);
    //               },
    //             ),
    //             TextButton(
    //               child: Text(BHBtnNo, style: TextStyle(color: Colors.blue, fontSize: 14)),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         );
    //       });
    // }
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ) {
            var value = snapshot.data!;
            if(value.data()!.containsKey("name")){
              name = value["name"];
            }
            if(value.data()!.containsKey("image")){
              urlImage = value["image"];
            }
            if(value.data()!.containsKey("email")){
              email = value["email"];
            }
            return Container(
              margin: EdgeInsets.only(top: 30.h),
              padding: EdgeInsets.all(14.
              w),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,

              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            backgroundColor: BHColorPrimary,
                            radius: 49,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 47,
                              child: urlImage == "" ? CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 45) :
                              CircleAvatar(
                                  backgroundImage:
                                  NetworkImage(urlImage),
                                  radius: 45)
                            ),
                          ),
                        ),
                        // Align(
                        //     alignment: Alignment.topCenter,
                        //     child: urlImage == "" ? CircleAvatar(
                        //         backgroundColor: Colors.grey,
                        //         radius: 45) :
                        //     CircleAvatar(
                        //         backgroundImage:
                        //         NetworkImage(urlImage),
                        //         radius: 45)
                        // ),
                        8.height,
                        Text(name ,style: TextStyle(
                            color: BHAppTextColorPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                        8.height,
                        Text(email, style: TextStyle(
                            color: BHAppTextColorSecondary, fontSize: 14)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [BoxShadow(color: BHGreyColor.withOpacity(
                            0.3), offset: Offset(0.0, 1.0), blurRadius: 2.0)
                        ],
                      ),
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              BHAccountInformationScreen(urlImage2: urlImage)
                                  .launch(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_circle, color: BHColorPrimary,
                                  size: 24.w,),
                                // Image.asset(BHInformationIcon, height: 23, width: 23,color: BHColorPrimary),
                                8.width,
                                Text(BHTxtAccountInformation, style: TextStyle(
                                    color: BHAppTextColorSecondary,
                                    fontSize: 14)).expand()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [BoxShadow(color: BHGreyColor.withOpacity(
                            0.3), offset: Offset(0.0, 1.0), blurRadius: 2.0)
                        ],
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              BHCancelledScreen().launch(context);
                            },
                            child: SizedBox(
                              height: 30.h,
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, color: BHColorPrimary,
                                    size: 24.w,),
                                  8.width,
                                  const Text("Cancelled Bookings", style: TextStyle(
                                      color: BHAppTextColorSecondary,
                                      fontSize: 14)).expand()
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          10.height,
                          GestureDetector(
                            onTap: () async{
                              BHCompletedBooking().launch(context);
                            },
                            child: SizedBox(
                              height: 30.h,
                              child: Row(
                                children: [
                                  Icon(Icons.book_online, color: BHColorPrimary,
                                    size: 24.w,),
                                  8.width,
                                  Text("Completed Bookings", style: TextStyle(
                                      color: BHAppTextColorSecondary,
                                      fontSize: 14)).expand()
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          10.height,
                          GestureDetector(
                            onTap: () {
                              ContactUs().launch(context);
                            },
                            child: SizedBox(
                              height: 30.h,
                              child: Row(
                                children: [
                                  Icon(Icons.call, color: BHColorPrimary,
                                    size: 24.w,),
                                  8.width,
                                  Text("Contact Us", style: TextStyle(
                                      color: BHAppTextColorSecondary,
                                      fontSize: 14)).expand()
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          10.height,
                          GestureDetector(
                            onTap: () {
                              // Loading().launch(context);
                              BHPrivacy().launch(context);
                            },
                            child: SizedBox(
                              height: 30.h,
                              child: Row(
                                children: [
                                  Icon(Icons.privacy_tip, color: BHColorPrimary,
                                    size: 24.w,),
                                  8.width,
                                  Text("Privacy Policy", style: TextStyle(
                                      color: BHAppTextColorSecondary,
                                      fontSize: 14)).expand()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:20.h, bottom: 20.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [BoxShadow(color: BHGreyColor.withOpacity(
                            0.3), offset: Offset(0.0, 1.0), blurRadius: 2.0)
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 20.w),
                      child: GestureDetector(
                        onTap: () async{
                          await ShowDialog3(context);
                        },
                        child: Row(
                          children: [
                            Image.asset(BHLogoutIcon, height: 23,
                                width: 23,
                                color: BHColorPrimary),
                            8.width,
                            Text(BHTxtLogout, style: TextStyle(
                                color: BHAppTextColorSecondary, fontSize: 14))
                                .expand(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else{
            return BHLoading();
          }
        }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
