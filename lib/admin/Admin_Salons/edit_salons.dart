import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../hairSalon/utils/BHColors.dart';
import '../../hairSalon/utils/widget_constant.dart';

class EditSalons extends StatefulWidget {
  const EditSalons({Key? key ,required this.id}) : super(key: key);
  final String id;

  @override
  State<EditSalons> createState() => _EditSalonsState();
}

class _EditSalonsState extends State<EditSalons> {
  bool check = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Future getInfo()async{
    await FirebaseFirestore.instance.collection("owners").doc(widget.id.toString()).get().then((value) {
      nameController.text = value["salon_name"];
      addressController.text = value["address"];
    });
  }
  @override
  Widget build(BuildContext context) {
    Future<void> _showDialog(String id) async {
      return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text("Delete this Salon",
                    style: TextStyle(
                        fontSize: 16, color: BHAppTextColorPrimary)),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel",
                      style: TextStyle(color: Colors.blue, fontSize: 14)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("OK",
                      style: TextStyle(color: Colors.blue, fontSize: 14)),
                  onPressed: () async{
                    await FirebaseFirestore.instance.collection("owners").doc(id).delete();
                    setState(() {
                      nameController.clear();
                      addressController.clear();
                      check=false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Salons"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: FutureBuilder(
        future: getInfo(),
        builder: (context,snapshot){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10,),
                    Text('Make Premium',style: TextStyle(fontSize: 17.0), ),
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                      value: check,
                      onChanged: (value) {
                        setState(() {
                          check = value!;
                        });
                      },
                    ),
                  ],
                ),
                10.height,
            Container(
              margin: EdgeInsets.only(left: 10.w, top: 5.h),
              child: Text(
                "Salon Name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.w,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
            ),
                10.height,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)
                      ),
                      fillColor: Colors.grey.shade200,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      hintText: "Salon Name",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xff8d8d8d),
                      ),
                      prefixIconColor: Color(0xff4f4f4f),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
                    ),
                  ),
                ),
                15.height,
                Container(
              margin: EdgeInsets.only(left: 10.w, top: 5.h),
              child: Text(
                "Salon Address",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.w,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
            ),
                10.height,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TextFormField(
                    controller: addressController,
                    keyboardType: TextInputType.number,
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)
                      ),
                      fillColor: Colors.grey.shade200,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      hintText: "Salon Name",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xff8d8d8d),
                      ),
                      prefixIconColor: Color(0xff4f4f4f),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
                    ),
                  ),
                ),
                15.height,
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: BHColorPrimary,
                    ),
                    width: MediaQuery.of(context).size.width*0.45,
                    child: TextButton(
                      onPressed: () async{
                        FocusManager.instance.primaryFocus?.unfocus();
                        await FirebaseFirestore.instance.collection("owners").doc(widget.id).update({
                          "salon_name":nameController.text,
                          "address":addressController.text,
                          "premium":check,
                        });
                        Fluttertoast.showToast(msg: "Owner updated successfully");
                      },
                      child: Text("Update Salon", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                50.height,
                Center(
                  child: Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width*0.45,
                    child: TextButton(
                      onPressed: () async{
                        FocusManager.instance.primaryFocus?.unfocus();
                        _showDialog(widget.id);
                      },
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: Text("Delete Salon", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),

          );
        },
      ) ,
    );
  }
}
