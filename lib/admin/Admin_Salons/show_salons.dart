import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/Admin_Salons/edit_salons.dart';
import 'package:salon/admin/users_list.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

class ShowSalons extends StatefulWidget {
  const ShowSalons({Key? key , required this.city}) : super(key: key);
  final String city;

  @override
  State<ShowSalons> createState() => _ShowSalonsState();
}

class _ShowSalonsState extends State<ShowSalons> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Salons (${widget.city})"),
       centerTitle: true,
       backgroundColor: BHColorPrimary,
     ),
     body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection("owners").where("city",isEqualTo: widget.city).snapshots(),
       builder: (context, snapshot) {
         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
           return Center(child: Text("No Data Found",style: TextStyle(color: Colors.black),),);
         }
         else {
           var value = snapshot.data!.docs;
           return ListView.builder(
               itemCount: snapshot.data!.docs.length,
               itemBuilder: (context, index) {
                 return GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>EditSalons(id:value[index].id.toString()))).then((value){
                       setState(() {
                       });
                     });
                   },
                   child: Card(
                     elevation: 3,
                     child: Container(
                       padding: EdgeInsets.symmetric(
                           horizontal: 10.w, vertical: 10.h),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               SizedBox(
                                   height: 50.h, width: 70.w,
                                   child: Image.network(
                                     value[index]["image"], fit: BoxFit.cover,)),
                               10.width,
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(value[index]["salon_name"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.w),),
                                   10.height,
                                   Text(value[index]["phone"]),
                                   10.height,
                                   Text("Capacity - "+value[index]["capacity"]),
                                 ],
                               ),
                             ],
                           ),
                           Column(
                             children: [
                               Text(value[index]["status"]==0?"Open":"Closed",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                               38.height,
                               Container(
                                   width: 130.w,
                                   child: Text(value[index]["email"],style: TextStyle(fontSize: 13.w),)),

                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                 );
               }
           );
         }
       }
     ),
   );
  }

}
