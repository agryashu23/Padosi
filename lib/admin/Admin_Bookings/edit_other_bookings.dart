import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/admin_home.dart';
import 'package:salon/admin/dashboard_screen.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

class EditOtherBookings extends StatefulWidget {
  const EditOtherBookings({Key? key, required this.title , required this.userId , required this.id ,required this.city}) : super(key: key);
  final String title;
  final String userId;
  final String id;
  final String city;

  @override
  State<EditOtherBookings> createState() => _EditOtherBookingsState();
}

class _EditOtherBookingsState extends State<EditOtherBookings> {

  List Items=[];
  bool loading=false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("employees").where("type",isEqualTo:widget.title).where("city",isEqualTo: widget.city).get().then((value){
      value.docs.forEach((element) {
        setState(() {
          Items.add({"name":element["name"],"contact":element["contact"],"type":element["type"],"image":element["image"]});
        });
      });
    });
  }
  String selectedValue="";
  String contactValue="+91";
  String nameValue="";
  String imageValue="";

  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context) {
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed:  () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("Confirm"),
        onPressed:  () async{
          await FirebaseFirestore.instance.collection("other_bookings").doc(widget.id).delete();
          await FirebaseFirestore.instance.collection("bookings").doc(widget.userId).collection("other").doc(widget.id).update({
            "status":"cancel",
            "alloted":false,
          });
          Fluttertoast.showToast(msg: "Booking cancelled");
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AdminHome()), (route) => false);
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Confirm Cancel"),
        content: Text("Are you sure want to cancel booking"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Allot ${widget.title}"),
        centerTitle: true,
      ),
      body: loading?BHLoading():Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.h,left: 20.w),
            child: Text("Allot Worker -",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.w),),
          ),
          25.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              isDense: true,
              hint: const Text(
                'Select Category',
                style: TextStyle(fontSize: 14),
              ),
              items: Items.map((item) => DropdownMenuItem(
                value: item["name"]+"-"+item["contact"]+"*"+item["image"],
                child: Row(
                  children: [
                    Image.network(item["image"],width: 40.w,height: 30.h,),
                    5.width,
                    Text(
                      item["name"],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    20.width,
                    Text(
                      item["contact"],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )).toList(),
              onChanged: (value) {
                selectedValue = value.toString();
              },
              onSaved: (value) {
                selectedValue = value.toString();
              },
              buttonStyleData: ButtonStyleData(
                height: 40.h,
                padding: EdgeInsets.only(left: 0, right: 10),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
              ),
            ),
          ),
          35.height,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green,

            ),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () async{
                if(selectedValue==""){
                  Fluttertoast.showToast(msg: "Please allot a worker");
                }
                else{
                  setState(() {
                    loading=true;
                  });
                  int i=0;
                  while(i<selectedValue.length){
                    if(selectedValue[i]=='-'){
                      i++;
                      break;
                    }
                    nameValue+=selectedValue[i];
                    i++;
                  }
                  while(i<selectedValue.length){
                    if(selectedValue[i]=='*'){
                      i++;
                      break;
                    }
                    contactValue+=selectedValue[i];
                    i++;
                  }
                  imageValue = selectedValue.substring(i);
                  await FirebaseFirestore.instance.collection("other_bookings").doc(widget.id).update({
                    "status":"alloted",
                    "alloted":true,
                    "officer_image":imageValue,
                    "officer":nameValue,
                    "contact":contactValue,
                  });
                  await FirebaseFirestore.instance.collection("bookings").doc(widget.userId).collection("other").doc(widget.id).update({
                    "status":"alloted",
                    "alloted":true,
                    "officer_image":imageValue,
                    "officer":nameValue,
                    "contact":contactValue,
                  });
                  setState(() {
                    loading=false;
                  });
                  Fluttertoast.showToast(msg: "Alloted Successfully");
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AdminHome()), (route) => false);
                }
              },
              child: Text("Allot Worker", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ),
          100.height,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 70.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () async{
                showAlertDialog(context);
              },
              child: Text("Cancel Allotment", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ),

        ],
      ),

    );
  }


 
}
