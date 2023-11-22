import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/BHBookAppointmentScreen.dart';
import 'package:salon/hairSalon/screens/BHDashedBoardScreen.dart';
import 'package:time_slot/controller/day_part_controller.dart';
import 'package:time_slot/model/time_slot_Interval.dart';
import 'package:time_slot/time_slot_from_interval.dart';
import '../../main/utils/AppWidget.dart';
import '../utils/BHColors.dart';
import '../utils/BHConstants.dart';
import '../utils/BHImages.dart';
import 'load_widget.dart';


class AppointmentStepper extends StatefulWidget {
  const AppointmentStepper({Key? key,required this.time, required this.day , required this.slot, required this.callback}) : super(key: key);
  final List time;
  final String day;
  final String slot;
  final StringCallback callback;

  @override
  State<AppointmentStepper> createState() => _AppointmentStepperState();
}

class _AppointmentStepperState extends State<AppointmentStepper> {
  DateTime? date;
  int currentStep = 0;
  bool loading =false;
  DayPartController dayPartController = DayPartController();
  String slots="";
  bool chosen=false;


  Future _pickDate() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: date!,
      firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
      lastDate: DateTime(DateTime.now().year ,DateTime.now().month+2),
    );
    if (dateTime != null) {
      setState(() {
        date = dateTime;
      });
      String days =DateFormat('EEEE').format(date!);
      widget.time.forEach((element) {
        if(element["title"]==days){
          currslot = element["timing"];
        }
      });
      if(currslot!="Closed"){
        setState(() {
          loading = true;
        });
          await convertTime(days, currslot);
      }
      else{
        setState(() {
          loading=false;
        });
      }
    }
  }

  DateTime selectTime = DateTime.now();
  int start=0;
  int end=0;

  Future convertTime(String day,String slot)async{
    String datee="";
    String datee2="";
    for(int i=0;i<slot.length;i++){
      if(slot[i]==' '){
        break;
      }
      datee+=slot[i];
    }
    for(int j=slot.length-1;j>=0;j--){
      if(slot[j]==' '){
        break;
      }
      datee2+=slot[j];
    }
    int start2=0;
    datee2 =datee2.split('').reversed.join();
    DateTime init= DateFormat("hh:mma").parse(datee);
    DateTime endit= DateFormat("hh:mma").parse(datee2);
    start2 = int.parse(DateFormat("HH").format(init));
    int current = int.parse(DateFormat("HH").format(DateTime.now()));
    print(day);
    String today = DateFormat('EEEE').format(DateTime.now()).toString();
    if(current>start2 && day ==today){
      start2 = current+1;
    }
    setState(() {
      start = start2;
      end = int.parse(DateFormat("HH").format(endit));
      loading= false;
    });
  }
  String currslot="";
  List finalItems=[];
  int amount=0;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    if(widget.slot!="Closed"){
      convertTime(widget.day,widget.slot);
    }
    currslot = widget.slot;

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [BoxShadow(color: BHGreyColor.withOpacity(0.3), offset: Offset(0.0, 1.0), blurRadius: 2.0)],
              ),
              child: ListTile(
                title: Text('Date : ${date!.day}/ ${date!.month}/ ${date!.year}', style: TextStyle(color: BHAppTextColorSecondary)),
                trailing: Icon(Icons.keyboard_arrow_down, color: BHAppTextColorSecondary),
                onTap: () async {
                  setState((){
                    loading=true;
                  });
                  await _pickDate();
                }
              ),
            ),
            loading?BHLoading():Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8.w),
              margin: EdgeInsets.only(top: 8.w),
              color: whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0.w),
                    child: Text(BHTxtAvailableSlot+":", style: TextStyle(fontSize: 14, color: BHAppTextColorPrimary, fontWeight: FontWeight.bold)),
                  ),
                  5.height,
                  currslot=="Closed"?Center(child: Text("Closed",style: TextStyle(fontSize: 16.w, color: Colors.red,
                      fontWeight: FontWeight.bold),)):TimesSlotGridViewFromInterval(
                    locale: "en",
                    initTime: selectTime,
                    selectedColor: BHColorPrimary,
                    crossAxisCount: 3,
                    timeSlotInterval:  TimeSlotInterval(
                      start: TimeOfDay(hour: start, minute: 00),
                      end: TimeOfDay(hour: end, minute: 00),
                      interval: Duration(hours: 1, minutes: 0),
                    ),
                    onChange: (value) {
                      setState(() {
                        chosen = true;
                        selectTime = value;
                        widget.callback(selectTime);
                      });
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
