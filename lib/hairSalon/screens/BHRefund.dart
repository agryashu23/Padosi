import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';
import 'package:salon/hairSalon/utils/widget_constant.dart';

class BHRefund extends StatefulWidget {
  const BHRefund({Key? key, required this.name, required this.book_id, required this.price, required this.id}) : super(key: key);
  final String name;
  final int book_id;
  final int price;
  final String id;

  @override
  State<BHRefund> createState() => _BHRefundState();
}

class _BHRefundState extends State<BHRefund> {
  Map<int, Widget> _children = {
    0: Text('UPI Details'),
    1: Text('Bank Account'),
  };
  int _currentSelection = 0;
  TextEditingController upiController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController nameController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Refund Details"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text("Enter the details to get your refund.",style: TextStyle(fontSize: 17.w,fontWeight: FontWeight.bold),),
              margin: EdgeInsets.symmetric(vertical: 15.h),
            ),
            SizedBox(
              width: context.width(),
              child: MaterialSegmentedControl(
                children: _children,
                horizontalPadding: EdgeInsets.symmetric(horizontal: 3.w),
                selectionIndex: _currentSelection,
                verticalOffset: 16,
                borderColor: Colors.grey,
                selectedColor: BHColorPrimary,
                unselectedColor: Colors.white,
                selectedTextStyle: TextStyle(color: Colors.white),
                unselectedTextStyle: TextStyle(color: Colors.black),
                borderRadius: 6.0,
                onSegmentTapped: (index) {
                  setState(() {
                    _currentSelection = int.parse(index.toString());
                  });
                },
              ),
            ),
            _currentSelection == 0 ? UPIDetails() : BankAccount(),
          ],
        ),
      ),
    );
  }

  Widget UPIDetails(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 0.5),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
      ),
      height: 310.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 15.h),
            child: labelControl("Appointment ID"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 6.h),
            child: Text("#"+widget.book_id.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 16.w),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 15.h),
            child: labelControl("UPI Number"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formControl(upiController,"(Paytm/Phonpe/GPay/BHIM UPI)"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("------------------------------   "),
              Text(" OR "),
              Text("   ------------------------------")
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 10.h),
            child: labelControl("UPI Address"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: upiIdController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Enter UPI Id",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
          ),
          20.height,
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: BHColorPrimary,
                borderRadius: BorderRadius.circular(10)
              ),
              width: MediaQuery.of(context).size.width*0.45,
              child: TextButton(
                onPressed: () async{
                  FocusManager.instance.primaryFocus?.unfocus();
                  if(upiController.text.isEmpty && upiIdController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.black54,
                      duration: Duration(seconds: 2),
                      content: Text("Please Enter All Details"),));
                  }
                  else{
                      await FirebaseFirestore.instance.collection("refund").add({
                        "booking_id":widget.book_id,
                        "account":accountController.text,
                        "user_id":FirebaseAuth.instance.currentUser!.uid,
                        "upi":upiController.text,
                        "upi_id":upiIdController.text,
                        "ifsc":ifscController.text,
                        "recipient_name":nameController.text,
                        "user_phone":FirebaseAuth.instance.currentUser!.phoneNumber,
                        "user_name":widget.name,
                        "price":widget.price,
                      });
                      await FirebaseFirestore.instance.collection("cancelled").doc(widget.id).update(
                          {
                            "mode":"refund",
                          });
                      Fluttertoast.showToast(msg: "Refund request is placed successfully");
                      Navigator.of(context).pop();
                  }
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text("Submit", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget BankAccount(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 0.5),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
      ),
      height: 430.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 15.h),
            child: labelControl("Appointment ID"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 6.h),
            child: Text("#"+widget.book_id.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 16.w),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 15.h),
            child: labelControl("Account Number"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formControl(accountController,"Enter Account Number"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 15.h),
            child: labelControl("IFSC Code"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: ifscController,
              textCapitalization: TextCapitalization.characters,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Enter IFSC Code",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w,top: 15.h),
            child: labelControl("Recipient Name"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Enter Recipient Name",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
              onFieldSubmitted: (value){
                FocusManager.instance.primaryFocus?.unfocus();

              },
            ),
          ),
          20.height,
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: BHColorPrimary,
                  borderRadius: BorderRadius.circular(10)
              ),
              width: MediaQuery.of(context).size.width*0.45,
              child: TextButton(
                onPressed: () async{
                  FocusManager.instance.primaryFocus?.unfocus();
                  if(accountController.text.isEmpty || ifscController.text.isEmpty || nameController.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.black54,
                      duration: Duration(seconds: 2),
                      content: Text("Please Enter All Details"),));
                  }
                  else{
                      await FirebaseFirestore.instance.collection("refund").add({
                        "booking_id":widget.book_id,
                        "account":accountController.text,
                        "user_id":FirebaseAuth.instance.currentUser!.uid,
                        "upi":upiController.text,
                        "upi_id":upiIdController.text,
                        "ifsc":ifscController.text,
                        "recipient_name":nameController.text,
                        "user_phone":FirebaseAuth.instance.currentUser!.phoneNumber,
                        "user_name":widget.name,
                        "price":widget.price,
                      });

                      await FirebaseFirestore.instance.collection("cancelled").doc(widget.id).update({
                          "mode":"refund",
                      });
                      Fluttertoast.showToast(msg: "Refund request is placed successfully");
                      Navigator.of(context).pop();
                  }
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text("Submit", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formControl(TextEditingController controller , String hint){
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
        hintText: hint,
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
