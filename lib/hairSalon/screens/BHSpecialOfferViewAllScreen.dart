import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main/utils/AppWidget.dart';
import '../model/BHModel.dart';
import '../utils/BHColors.dart';
import 'BHDetailScreen.dart';
import 'load_widget.dart';

class BHSpecialOfferViewAllScreen extends StatefulWidget {
  static String tag = '/SpecialOfferViewAllScreen';

  @override
  BHSpecialOfferViewAllScreenState createState() =>
      BHSpecialOfferViewAllScreenState();
}

class BHSpecialOfferViewAllScreenState
    extends State<BHSpecialOfferViewAllScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Notifications",
            style: TextStyle(
                color: BHAppTextColorPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            finish(context);
          },
          child: Icon(Icons.arrow_back, color: blackColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notifications").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState ==ConnectionState.waiting){
            return BHLoading();
          }
          else if(!snapshot.hasData){
            return Center(child: Text("No Notifications"),);
          }
          else {
            var value = snapshot.data!.docs;
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  if (snapshot.hasData) {
                    return Card(
                      elevation: 5,
                      child: Container(
                        height: 60.h,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(value[index]["title"], style: TextStyle(
                                fontSize: 17.w,
                                color: BHAppTextColorPrimary,
                                fontWeight: FontWeight.bold)),
                            10.height,
                            Text(value[index]["subtitle"], style: TextStyle(
                                fontSize: 15.w,
                                color: Colors.red,
                                fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    );
                  }
                  else {
                    return Center(child: Text("No NOtifications"),);
                  }
                });
          }
        }
      ),
    );
  }
}
