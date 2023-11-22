import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';
import 'package:salon/hairSalon/utils/confirmation_page.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'dart:io';

import '../../owner/location_class.dart';
import '../utils/widget_constant.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({Key? key, required this.title, required this.image}) : super(key: key);
  final String title;
  final String image;
  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  List<Locations> locations = [];
  String status = '';
  String location = "Search Your Address";
  double latitude=0.0;
  double longitude=0.0;
  bool loading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  String name="";
  String mobile ="";


  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
      name = value["name"];
      mobile = value["phone"];
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Create Booking"),
        centerTitle: true,
      ),
      body: loading?BHLoading():Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Image.network(widget.image,height: 120.h,width: context.width(),fit: BoxFit.fitWidth,),
                ),
                4.height,

                labelText("Title"),
                4.height,
                Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w,top: 0),
                  child: TextFormField(
                    controller: titleController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixStyle: TextStyle(fontSize: 16),
                      fillColor: Colors.grey.shade200,
                      isDense:true,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xff8d8d8d),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIconColor: Color(0xff4f4f4f),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: BHAppDividerColor)),
                    ),
                    validator: (value) {
                      if (value != null) {
                        return null;
                      } else
                        return 'Field cannot be empty';
                    },
                  ),
                ),
                20.height,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:20.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                        controller: dateController, //editing controller of this TextField
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today), //icon of text field
                            hintText: "Choose Date" ,
                            border: InputBorder.none//label text of field
                        ),
                        readOnly: true,  // when true user cannot edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(), //get today's date
                              firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101)
                          );
                          if(pickedDate != null ){
                            print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                            print(formattedDate); //formatted date output using intl package =>  2022-07-04
                            //You can format date as per your need

                            setState(() {
                              dateController.text = formattedDate; //set foratted date to TextField value.
                            });
                          }else{
                            print("Date is not selected");
                          }
                        }
                    ),
                  ),
                ),

                10.height,
                labelText("*Complete Address"),
                multiLineForm(controller: addressController,lines: 2),
                10.height,
                labelText("*City"),
                InkWell(
                    onTap: () async {
                      Prediction? place = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: "AIzaSyC1A7zM67k09UeHvPcf0DJo_OHcx9pdwQc",
                          mode: Mode.overlay,
                          language: 'en',
                          radius: 1000000,
                          types: ["(cities)"],
                          strictbounds: false,
                          components: [Component(Component.country, 'in')],
                          //google_map_webservice package
                          onError: (err){
                            print(err);
                          }
                      );
                      if(place != null){
                        String ans="";
                        for(int i=0;i<place.description.toString().length;i++){
                          if(place.description.toString()[i]==',' || place.description.toString()[i]==' '){
                            break;
                          }
                          ans+=place.description.toString()[i];
                        }
                        setState((){
                          cityController.text = ans.trim();
                        });
                      }
                    },
                    child:Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Card(
                        child: Container(
                            padding: EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width - 40,
                            child: ListTile(
                              title:Text(cityController.text, style: TextStyle(fontSize: 17.w),),
                              trailing: Icon(Icons.search),
                              dense: true,
                            )
                        ),
                      ),
                    )
                ),
                // 15.height,
                // labelText("Issue Description"),
                // multiLineForm(controller: descController, lines: 2),
                25.height,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 120.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: BHColorPrimary,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () async{
                      if(dateController.text.isEmpty ){
                        Fluttertoast.showToast(msg: "Please select Date");
                      }
                      else if(cityController.text.isEmpty ){
                        Fluttertoast.showToast(msg: "Please select City");
                      }
                      else if(addressController.text.isEmpty ){
                        Fluttertoast.showToast(msg: "Please select Address");
                      }
                      else if(formGlobalKey.currentState!.validate()){
                        setState(() {
                          loading = true;
                        });
                        final document = await FirebaseFirestore.instance.collection("bookings").doc(FirebaseAuth.instance.currentUser!.uid).collection("other").add({
                          "title":widget.title,
                          "image":widget.image,
                          "address":addressController.text,
                          "city":cityController.text,
                          "alloted":true,
                          "officer":"",
                          "contact":"",
                          "date":dateController.text,
                          "status":"pending",
                        });
                        await FirebaseFirestore.instance.collection("other_bookings").doc(document.id).set({
                          "title":widget.title,
                          "image":widget.image,
                          "address":addressController.text,
                          "city":cityController.text,
                          "alloted":true,
                          "officer":"",
                          "contact":"",
                          "date":dateController.text,
                          "status":"pending",
                          "user_id":FirebaseAuth.instance.currentUser!.uid.toString(),
                          "user_name":name,
                          "user_phone":mobile,
                          "created_at":DateTime.now(),
                        });
                        dateController.clear();
                        addressController.clear();
                        cityController.clear();
                        setState(() {
                          loading = false;
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (contaxt)=>ConfirmationPage()));
                      }
                    },
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Text("Submit", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
