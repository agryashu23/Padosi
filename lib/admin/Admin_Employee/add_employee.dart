import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:salon/hairSalon/utils/widget_constant.dart';
import 'package:path/path.dart' as Path;
import 'package:salon/admin/Admin_Feed/show_feed.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import '../../main/utils/AppWidget.dart';
import '../../hairSalon/utils/BHColors.dart';


class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  String selectedValue="";
  List Items=[];
  final formGlobalKey = GlobalKey<FormState>();
  bool loading = false;
  File? image2;
  firebase_storage.Reference? ref;
  String urlImage = "";
  CollectionReference? imgRef;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        image2 = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  Future uploadFiles() async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('employees/${Path.basename(image2!.path)}');
    await ref!.putFile(image2!).whenComplete(() async {
      await ref!.getDownloadURL().then((value) async {
        imgRef?.add({"url": value});
        setState(() {
          urlImage = value;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("categories").get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          Items.add(element["name"]);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: BHColorPrimary,
        title: Text("Add Employee"),
        centerTitle: true,
      ),
      body: loading?BHLoading():Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
        child: Form(
          key: formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: ()async{
                  await pickImage();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: BHColorPrimary,
                    radius: 47,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 45,
                      child: image2 == null
                          ? CircleAvatar(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.grey,
                          // backgroundImage:
                          // Image.network(BHWalkThroughImg1).image,
                          radius: 43)
                          : CircleAvatar(
                          radius: 43,
                          backgroundImage: FileImage(image2!)),
                    ),
                  ),
                ),
              ),
              10.height,
              Text(
                "*Name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.w,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
              10.height,
              BoxForms(nameController, "Enter Name", "alpha"),
              15.height,
              Text(
                "*Contact Number",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.w,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
              10.height,
              BoxForms(contactController, "Enter Contact Number", "Number"),
              15.height,
              Text(
                "Address",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.w,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
              10.height,
              BoxForms(addressController, "Enter Address", "alpha"),
              15.height,
              Text(
                "*Type",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.w,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
              10.height,
              DropdownButtonFormField2(
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
                items: Items.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
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
              15.height,
              Text(
                "*Choose City",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.w,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
              8.height,
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
                  child:Card(
                    child: Container(
                        padding: EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListTile(
                          title:Text(cityController.text, style: TextStyle(fontSize: 17.w),),
                          trailing: Icon(Icons.search),
                          dense: true,
                        )
                    ),
                  )
              ),
              30.height,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: BHColorPrimary,
                ),
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () async{
                    if(cityController.text.isEmpty || selectedValue==""){
                      Fluttertoast.showToast(msg: "Enter City or Type");
                    }
                    else if (formGlobalKey.currentState!.validate()) {
                      setState(() {
                        loading =true;
                      });
                      await uploadFiles();
                      await FirebaseFirestore.instance.collection("employees").add({
                        "name":nameController.text,
                        "image":urlImage,
                        "contact":contactController.text,
                        "address":addressController.text,
                        "type":selectedValue,
                        "city":cityController.text
                      });
                      nameController.clear();
                      cityController.clear();
                      contactController.clear();
                      selectedValue="";
                      addressController.clear();
                    }
                    setState(() {
                      loading = false;
                    });
                    Fluttertoast.showToast(msg: "Employee Added");
                  },
                  child: Text("Add Employee", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
