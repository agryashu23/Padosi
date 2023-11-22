import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../../main/utils/AppWidget.dart';

class ShowEmployee extends StatefulWidget {
  const ShowEmployee({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<ShowEmployee> createState() => _ShowEmployeeState();
}

class _ShowEmployeeState extends State<ShowEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("${widget.name} List"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection("employees").where("type",isEqualTo: widget.name).get(),
            builder: (context, snapshot) {
               if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: BHLoading(),);
              }
              else if(!snapshot.hasData|| snapshot.data!.docs.isEmpty){
              return Center(child: Text("No Data Found"),);
              }
              else if (snapshot.hasData ) {
                var value = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w,vertical: 5.h),
                          child: Row(
                            children: [
                              Image.network(value[index]["image"],width: 90.w,height: 50.h,fit: BoxFit.cover,),
                              10.width,
                              Container(
                                width: 150.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value[index]["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: BHAppTextColorPrimary,
                                          fontSize: 14.w),
                                    ),
                                    5.height,
                                    Text(
                                      value[index]["contact"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          fontSize: 14.w),
                                    ),
                                    5.height,
                                    Text(
                                      value[index]["city"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 14.w),
                                    ),
                                    5.height,
                                    Text(
                                      value[index]["address"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.w),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: ()async{
                                  await FirebaseFirestore.instance.collection("employees").doc(value[index].id).delete();
                                  setState(() {
                                  });
                                  FirebaseStorage.instance.refFromURL(value[index]["image"]).delete();
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: BHColorPrimary,
                                      decoration: TextDecoration.underline,
                                      fontSize: 16.w),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              }
              else{
                return Center(child: Text("No Categories"),);
              }
            }
        ),
      ),
    );
  }
}
