import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../../main/utils/AppWidget.dart';
import 'category_form.dart';
import 'load_widget.dart';

class BHViewAllCategories extends StatefulWidget {
  const BHViewAllCategories({Key? key}) : super(key: key);

  @override
  State<BHViewAllCategories> createState() => _BHViewAllCategoriesState();
}

class _BHViewAllCategoriesState extends State<BHViewAllCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("All Categories"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("categories")
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState ==
          ConnectionState.waiting) {
        return BHLoading();
      }
      else if (snapshot.hasData) {
        var value = snapshot.data!.docs;
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          CategoryForm(
                              title: value[index]["name"],
                              image: value[index]["image"])));
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 15.w),
                  color: Colors.grey.shade100,
                  elevation: 4,
                  child: Container(
                    height: 80.h,
                    // padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          // borderRadius: BorderRadius.all(
                          //   Radius.circular(10),
                          // ),
                          child: commonCacheImageWidget(value[index]["image"], 80.h,
                              width: 80.w, fit: BoxFit.cover),
                        ),
                        25.width,
                        Text(
                          value[index]["name"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: BHAppTextColorPrimary,
                              fontSize: 16.w),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        );

      }
      return BHLoading();
    }),
    );
  }
}
