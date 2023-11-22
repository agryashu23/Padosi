import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../hairSalon/utils/BHColors.dart';

class OwnerChangeSlot extends StatefulWidget {
  static String tag = '/OwnerChangeSlot';

  const OwnerChangeSlot({Key? key ,required this.title , required this.idx}) : super(key: key);

  final String title;
  final int idx;
  @override
  State<OwnerChangeSlot> createState() => _OwnerChangeSlotState();
}

class _OwnerChangeSlotState extends State<OwnerChangeSlot> {
  TextEditingController timeinput = TextEditingController();
  TextEditingController timeoutput = TextEditingController();
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Slots"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.h),
              child: Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.w,color: Colors.blue),)),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 30.h),
              child:Center(
                  child:TextFormField(
                    controller: timeinput,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15)
                    ),
                      prefixIcon: Icon(Icons.access_time_outlined),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
                        hintText: "Open Time"
                    ),

                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime =  await showTimePicker(
                        initialTime: TimeOfDay(hour: 9, minute: 00),
                        context: context,
                      );
                      if(pickedTime != null ){
                        DateTime tempDate = DateFormat("hh:mm").parse(
                            pickedTime.hour.toString() +
                                ":" + pickedTime.minute.toString());
                        var dateFormat = DateFormat("h:mm a");
                        final time = dateFormat.format(tempDate);
                        setState(() {
                          timeinput.text = time;
                        });
                      }else{
                        print("Time is not selected");
                      }
                    },
                  )
              )
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child:Center(
                  child:TextFormField(
                    controller: timeoutput,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15)
                    ),
                      prefixIcon: Icon(Icons.access_time_outlined),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
                        hintText: "Closing Time"
                    ),

                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime =  await showTimePicker(
                        initialTime: TimeOfDay(hour: 9, minute: 00),
                        context: context,
                      );
                      if(pickedTime != null ){
                        DateTime tempDate = DateFormat("hh:mm").parse(
                            pickedTime.hour.toString() +
                                ":" + pickedTime.minute.toString());
                        var dateFormat = DateFormat("h:mm a");
                        final time = dateFormat.format(tempDate);
                        setState(() {
                          timeoutput.text = time;
                        });
                      }else{
                        print("Time is not selected");
                      }
                    },
                  )
              )
          ),
          20.height,
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
               Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0),
                child: Text(
                  'OR',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.w,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          15.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10,),
              Text('Closed',style: TextStyle(fontSize: 17.0), ),
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.red,
                value: status,
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),
            ],
          ),
          20.height,
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          50.height,
          Center(
            child: Container(
              color: BHColorPrimary,
              width: MediaQuery.of(context).size.width*0.45,
              child: TextButton(
                onPressed: () async{
                  if((timeinput.text.isEmpty || timeoutput.text.isEmpty) && status==false){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.tealAccent,
                      duration: Duration(seconds: 2),
                      content: Text("Please select a slot"),));
                  }
                  else {
                    DocumentSnapshot snapshot = await FirebaseFirestore.instance
                        .collection('owners').doc(
                        FirebaseAuth.instance.currentUser!.uid).get();
                    Map<String, dynamic> data = snapshot.data() as Map<
                        String,
                        dynamic>;
                    List<dynamic> updatedList = List.from(data['timeslots']);
                    updatedList[widget.idx] = {
                      "timing": status ? "Closed" : "${timeinput
                          .text} - ${timeoutput.text}",
                      "title": widget.title,
                    };
                    await FirebaseFirestore.instance.collection('owners').doc(
                        FirebaseAuth.instance.currentUser!.uid).update({
                      'timeslots': updatedList,
                    });
                    Fluttertoast.showToast(msg: "Slot Updated Successfully");
                    Navigator.of(context).pop();
                  }

                },
                child: Text("Update Slot", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
