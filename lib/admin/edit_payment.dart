import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../hairSalon/utils/BHColors.dart';

class EditPayment extends StatefulWidget {
  const EditPayment({Key? key ,required this.offline, required this.online ,required this.phone, required this.id}) : super(key: key);
  final int online;
  final int offline;
  final String phone;
  final String id;

  @override
  State<EditPayment> createState() => _EditPaymentState();
}

class _EditPaymentState extends State<EditPayment> {
  TextEditingController onlineController = TextEditingController();
  TextEditingController offlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    onlineController.text = widget.online.toString();
    offlineController.text = widget.offline.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: GestureDetector(
                    onTap: (){
                      UrlLauncher.launch("tel:${widget.phone}");
                    },
                    child: Icon(Icons.call_rounded,color: Colors.blue,size: 40.w,)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w,top: 15.h),
              child: labelControl("Online"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: formControl(onlineController),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w,top: 15.h),
              child: labelControl("Offline"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: formControl(offlineController),
            ),
            GestureDetector(
              onTap: ()async{
                await FirebaseFirestore.instance.collection("payments").doc(widget.id).update({
                    "online":int.parse(onlineController.text),
                });
              },
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30.h),
                  padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 15.h),
                  decoration: BoxDecoration(
                    color: BHColorPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.w),),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
  Widget formControl(TextEditingController controller ){
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.grey)
        ),
        fillColor: Colors.grey.shade200,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        prefixText: "\u{20B9} ",
        hintStyle: TextStyle(
          fontSize: 15,
          color: Color(0xff8d8d8d),
        ),
        prefixIconColor: Color(0xff4f4f4f),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
      ),
    );
  }
  Widget labelControl(String s){
    return Container(
      child: Text(
        s,
        style: TextStyle(
            color: Colors.black,
            fontSize: 14.w,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2),
      ),
    );
  }
}
