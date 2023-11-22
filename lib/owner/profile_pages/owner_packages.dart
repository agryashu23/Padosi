import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';

import '../../hairSalon/utils/BHColors.dart';
import '../../hairSalon/utils/BHImages.dart';
import 'add_package.dart';


class OwnerPackages extends StatefulWidget {
  static String tag = '/OwnerPackages';


  @override
  State<OwnerPackages> createState() => _OwnerPackagesState();
}

class _OwnerPackagesState extends State<OwnerPackages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        centerTitle: true,
        title: Text("Packages"),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddOwnerPackage())).then((value){
                setState(() {
                });
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              margin: EdgeInsets.only(bottom: 8.h,top: 8.h,right: 10.w),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("Add New"),

            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid).collection("package").get(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            var value = snapshot.data!.docs;
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(top: 10.h, left: 5.w, right: 5.w),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 6.h, horizontal: 8.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 85.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        value[index]["image"], width: 80.w,
                                        height: 70.h,
                                        fit: BoxFit.cover,),
                                    ),
                                    10.height,
                                    Text(
                                      '\u{20B9} ${value[index]["price"]}',
                                      style: TextStyle(
                                          fontSize: 15.w, color: Colors.black,fontWeight: FontWeight.bold),),
                                    10.height,
                                    Text(
                                      '${value[index]["duration"]} min',
                                      style: TextStyle(
                                          fontSize: 15.w, color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(value[index]["name"], style: TextStyle(
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),),
                                  5.height,
                                  // List.generate(1000,(counter) => "Item $counter");
                                  ...List.generate(
                                      value[index]["services"].length, (idx) {
                                          return  Text(
                                            value[index]["services"][idx],
                                            style: TextStyle(
                                                fontSize: 13.w, color: Colors.grey),);
                                  })
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 120.w,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap:()async{
                                    await FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid).collection("package").doc(value[index].id).delete();
                                    setState(() {
                                    });
                                    Fluttertoast.showToast(msg: "Package Deleted");
                                    },
                                    child: Icon(Icons.delete, color: Colors.red, size: 30.w,)),
                                10.height,
                                Text(value[index]["desc"], style: TextStyle(
                                    fontSize: 12.w,
                                    color: Colors.black),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
              }
          );
          }
          else{
            return Center(child:BHLoading());
          }
        }
      ),
    );
  }
}
