import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/Admin_Employee/add_employee.dart';
import 'package:salon/admin/Admin_Employee/show_employee.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../../main/utils/AppWidget.dart';


class EmployeeCategory extends StatefulWidget {
  const EmployeeCategory({Key? key}) : super(key: key);

  @override
  State<EmployeeCategory> createState() => _EmployeeCategoryState();
}

class _EmployeeCategoryState extends State<EmployeeCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Choose Category",style: TextStyle(fontSize: 17.w),),
        actions: [
          GestureDetector(
            onTap: (){
              AddEmployee().launch(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 5.w,top: 5.h,bottom: 5.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w,),
              child: Text("Add Employee"),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 10.h),
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection("categories").get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var value = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          ShowEmployee(name:value[index]["name"]).launch(context);
                        },
                        child: Card(
                          color: Colors.grey.shade200,
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          elevation: 4,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: commonCacheImageWidget(value[index]["image"], 50.h,
                                      width: 60.w, fit: BoxFit.fitWidth),
                                ),
                                20.width,
                                Text(
                                  value[index]["name"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: BHAppTextColorPrimary,
                                      fontSize: 14),
                                ),
                              ],
                            ),
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
