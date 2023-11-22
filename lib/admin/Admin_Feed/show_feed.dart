import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../hairSalon/utils/BHColors.dart';
import '../../main/utils/AppWidget.dart';


class ShowFeed extends StatefulWidget {
  const ShowFeed({Key? key}) : super(key: key);

  @override
  State<ShowFeed> createState() => _ShowFeedState();
}

class _ShowFeedState extends State<ShowFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Show Feed"),
        backgroundColor: BHColorPrimary,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("feeds").get(),
         builder: (context, snapshot) {
        if (snapshot.hasData) {
          var value = snapshot.data!.docs;
          return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                ShowFeedDetails(details:value[index]["feed"]).launch(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                padding: EdgeInsets.only(bottom: 3.h),
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
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: commonCacheImageWidget(value[index]["image"], 90.h,
                          width: context.width(), fit: BoxFit.fitHeight),
                    ),
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
                              await FirebaseFirestore.instance.collection("feeds").doc(value[index].id).delete();
                              setState(() {
                              });
                              FirebaseStorage.instance.refFromURL(value[index]["image"]).delete();

                            },
                            child: Container(
                              width: 70.w,
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: BHColorPrimary,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16.w),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    3.height
                  ],
                ),
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
class ShowFeedDetails extends StatelessWidget {
  const ShowFeedDetails({Key? key, required this.details}) : super(key: key);

  final String details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed Details"),
        backgroundColor: BHColorPrimary,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
        child: SelectableText(details),
      ),
    );
  }
}

