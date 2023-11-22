import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';

import '../../hairSalon/utils/BHColors.dart';
import '../../hairSalon/utils/BHImages.dart';
import 'add_services.dart';


class OwnerServices extends StatefulWidget {
  static String tag = '/OwnerServices';


  @override
  State<OwnerServices> createState() => _OwnerServicesState();
}

class _OwnerServicesState extends State<OwnerServices> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        centerTitle: true,
        title: Text("Services"),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddServiceOwner())).then((value){
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
        future:FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid).collection("service").get(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            var value = snapshot.data!.docs;
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(top: 12.h, left: 5.w, right: 5.w),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 9.h, horizontal: 10.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  BHWalkThroughImg1, width: 70.w,
                                  height: 60.h,
                                  fit: BoxFit.cover,),
                              ),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(value[index]["name"], style: TextStyle(
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),),
                                  Text(value[index]["category"], style: TextStyle(
                                      fontSize: 13.w, color: Colors.grey),),
                                  1.height,
                                  Text("\u{20B9} ${value[index]["price"]}", style: TextStyle(
                                      fontSize: 15.w,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),),
                                  1.height,
                                  Text(value[index]["duration"]+"min", style: TextStyle(
                                      fontSize: 13.w, color: Colors.grey),),
                                ],
                              ),

                            ],
                          ),
                        GestureDetector(
                            onTap: ()async{
                              await FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid).collection("service").doc(value[index].id).delete();
                              setState(() {
                              });
                              Fluttertoast.showToast(msg: "Service Deleted");
                            },
                            child: Icon(Icons.delete, color: Colors.red, size: 30.w,))

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
