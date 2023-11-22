import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../../main/utils/AppWidget.dart';

class BHShowFeed extends StatefulWidget {
  static String tag = '/BHShowFeed';
  final String image;
  final String title;
  final String text;
  BHShowFeed({required this.image, required this.title,required this.text});

  @override
  State<BHShowFeed> createState() => _BHShowFeedState();
}

class _BHShowFeedState extends State<BHShowFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: commonCacheImageWidget(widget.image, 150.h, width: 360.w, fit: BoxFit.cover),
            ),
            10.height,
            Center(
              child: Text(widget.title,style: TextStyle(fontSize: 18.w, color: BHAppTextColorPrimary, fontWeight: FontWeight.bold),),
            ),
            10.height,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.w),
              child: Text(widget.text),
            )
          ],
        ),
      ),
    );
  }
}
