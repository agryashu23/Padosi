import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../hairSalon/utils/BHColors.dart';

class OwnerPayment extends StatefulWidget {
  const OwnerPayment({Key? key}) : super(key: key);

  @override
  State<OwnerPayment> createState() => _OwnerPaymentState();
}

class _OwnerPaymentState extends State<OwnerPayment> {
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

  Future getData()async{
    await FirebaseFirestore.instance.collection("owners").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
      if(value.data()!.containsKey("account")){
        accountController.text = value["account"];
      }
      if(value.data()!.containsKey("upi")){
        upiController.text = value["upi"];
      }
      if(value.data()!.containsKey("upi_id")){
        upiIdController.text = value["upi_id"];
      }
      if(value.data()!.containsKey("ifsc")){
        ifscController.text = value["ifsc"];
      }
      if(value.data()!.containsKey("recipient_name")){
        nameController.text = value["recipient_name"];
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Payment Details"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          // else if(!snapshot.hasData){
          //   return Center(child: Text("No Data",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold),),);
          // }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Text(
                    "Enter your payment details",
                    style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.bold),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 18.h),
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
          );
        }
      ),
    );
  }

  Widget UPIDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
      ),
      height: 310.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 15.h),
            child: labelControl("UPI Number"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formControl(upiController, "(Paytm/Phonpe/GPay/BHIM UPI)"),
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
            padding: EdgeInsets.only(left: 15.w, top: 10.h),
            child: labelControl("UPI Address"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formControl(upiIdController, "Enter UPI Id"),
          ),
          20.height,
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: BHColorPrimary,
                  borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("owners")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "account": accountController.text,
                    "upi": upiController.text,
                    "upi_id": upiIdController.text,
                    "ifsc": ifscController.text,
                    "recipient_name": nameController.text,
                  });
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text("Submit",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget BankAccount() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
      ),
      height: 430.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 15.h),
            child: labelControl("Account Number"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formControl(accountController, "Enter Account Number"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 15.h),
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
                    borderSide: new BorderSide(color: Colors.grey)),
                fillColor: Colors.grey.shade200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Enter IFSC Code",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 15.h),
            child: labelControl("Recipient Name"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)),
                fillColor: Colors.grey.shade200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Enter Recipient Name",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: BHColorPrimary)),
              ),
              onFieldSubmitted: (value) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          20.height,
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: BHColorPrimary,
                  borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("owners")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "account": accountController.text,
                    "upi": upiController.text,
                    "upi_id": upiIdController.text,
                    "ifsc": ifscController.text,
                    "recipient_name": nameController.text,
                  });
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text("Submit",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formControl(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.grey)),
        fillColor: Colors.grey.shade200,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 15,
          color: Color(0xff8d8d8d),
        ),
        prefixIconColor: Color(0xff4f4f4f),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
      ),
    );
  }

  Widget labelControl(String s) {
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
