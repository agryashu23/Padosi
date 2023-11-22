import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:im_stepper/stepper.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:toggle_switch/toggle_switch.dart';
import '../../hairSalon/utils/BHColors.dart';
import '../../hairSalon/utils/widget_constant.dart';
import '../owner_dahboard.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../location_class.dart';
import 'package:intl/intl.dart';
import 'loading.dart';

class OwnerStepper extends StatefulWidget {
  static String tag = '/OwnerStepper';

  @override
  State<OwnerStepper> createState() => _OwnerStepperState();
}

class _OwnerStepperState extends State<OwnerStepper> {
  
  int activeStep = 0;
  int upperBound = 5;
  int gender =0;
  List<Locations> locations = [];
  String status = '';
  String location = "Search Your Address";
  String? _currentAddress;
  double latitude=0.0;
  double longitude=0.0;

  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  String capacity = "";
  List<String> Capacity = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  File? image2;
  Future pickImage(ImageSource source, File? img) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        img = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    return img;
  }

  final formGlobalKey = GlobalKey<FormState>();
  final formGlobalKey2 = GlobalKey<FormState>();

  // String status3= "";
  // _getLocations(pincode) async {
  //   setState(() {
  //     status3 = 'Please wait...';
  //   });
  //   final JsonDecoder _decoder = const JsonDecoder();
  //   await http
  //       .get(Uri.parse("http://www.postalpincode.in/api/pincode/$pincode"))
  //       .then((http.Response response) {
  //     final String res = response.body;
  //     final int statusCode = response.statusCode;
  //
  //     if (statusCode < 200 || statusCode > 400) {
  //       throw Exception("Error while fetching data");
  //     }
  //
  //     setState(() {
  //       var json = _decoder.convert(res);
  //       var tmp = json['PostOffice'] as List;
  //       locations =
  //           tmp.map<Locations>((json) => Locations.fromJson(json)).toList();
  //       status3 = 'All Locations at Pincode ' + pincode;
  //     });
  //   });
  // }

  List<File> selectedImages = [];

  Future getImages() async {
    final pickedFile = await ImagePicker()
        .pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick.isNotEmpty) {
          if (xfilePick.length > 3) {
            xfilePick.length = 3;
          }
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  TextEditingController serviceName = TextEditingController();
  TextEditingController servicePrice = TextEditingController();
  TextEditingController serviceDuration = TextEditingController();
  TextEditingController serviceDescription = TextEditingController();
  List<String> Items = [];
  List services = [];
  String selectedValue = "";
  firebase_storage.Reference? ref;
  String urlImage = "";
  CollectionReference? imgRef;
  List packageEntry=[];


  Future uploadFiles() async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('owners/${Path.basename(image2!.path)}');
    await ref!.putFile(image2!).whenComplete(() async {
      await ref!.getDownloadURL().then((value) async {
        imgRef?.add({"url": value});
        setState(() {
          urlImage = value;
        });
      });
    });
  }
  List gallery=[];
  Future uploadFiles2(File? imgg) async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('owners/${Path.basename(imgg!.path)}');
    await ref!.putFile(imgg).whenComplete(() async {
      await ref!.getDownloadURL().then((value) async {
        imgRef?.add({"url": value});
        setState(() {
          gallery.add(value);
        });
      });
    });
  }
  List packImage=[];

  Future uploadFiles3(File? imggg) async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('owners/${Path.basename(imggg!.path)}');
    await ref!.putFile(imggg).whenComplete(() async {
      await ref!.getDownloadURL().then((value) async {
        imgRef?.add({"url": value});
        setState(() {
          packImage.add(value);
        });
      });
    });
  }


  TextEditingController packageName = TextEditingController();
  TextEditingController packagePrice = TextEditingController();
  TextEditingController packageDuration = TextEditingController();
  TextEditingController packageDescription = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  List packages = [];
  File? image3;
  List<String> selectedItems = [];

  TextEditingController timeinput = TextEditingController();
  TextEditingController timeoutput = TextEditingController();
  List days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  List timings = [];


  List slots = [];
  String selectedValue2 = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        return onWillPop(context);
      },
      child: loading?Loading():Scaffold(
        appBar: AppBar(
          title: Text(
            'Register Your Salon',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: BHColorPrimary,
          toolbarHeight: 40.h,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              IconStepper(
                activeStepColor: BHColorPrimary,
                stepColor: Colors.grey.shade300,
                enableNextPreviousButtons: false,
                enableStepTapping: false,
                lineLength: 40,
                stepRadius: 20.0,
                icons: [
                  Icon(Icons.info_outline_rounded),
                  Icon(Icons.photo),
                  Icon(Icons.miscellaneous_services_rounded),
                  Icon(Icons.list_alt),
                  Icon(Icons.access_time),
                ],
                activeStep: activeStep,
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
              ),
              Expanded(
                child: handleProcess(activeStep),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  previousButton(),
                  activeStep ==4?submitButton() : nextButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return GestureDetector(
        onTap: () async {
          if(activeStep==0){
            if (addressController.text.isEmpty || cityController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please Enter All Details')),
              );
            }
            else if(image2==null){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please Enter Salon Image')),
              );
            }
            else if(capacity==""){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please Enter Salon Capacity')),
              );
            }
            else{
                setState(() {
                  activeStep++;
                });
            }
          }
          else if(activeStep==1){
            if(selectedImages.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add an image')));
            }
            else{
              setState(() {
              activeStep++;
              });
              }
          }
          else if(activeStep==2){
            if(services.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add a Service')));
            }
            else{
              setState(() {
                activeStep++;
              });
            }
          }
          else if(activeStep==3){
            print(capacity);
            if(packages.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add a Package')));
            }
            else{
              setState(() {
                activeStep++;
              });
            }
          }

        },
        child: prevNext("Next"));
  }

  Widget submitButton() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          loading=true;
        });
        await uploadFiles();
        for(int i=0;i<selectedImages.length;i++){
          await uploadFiles2(selectedImages[i]);
        }
        for(int i=0;i<packages.length;i++){
          await uploadFiles3(packages[i]["image"]);
        }
        var locations = await getLocations("${addressController.text},${cityController.text}");
        setState(() {
          latitude = locations[0].latitude;
          longitude = locations[0].longitude;
        });

        await FirebaseFirestore.instance.collection("owners").doc(FirebaseAuth.instance.currentUser!.uid.toString()).update({
          "address":addressController.text,
          "alternate_contact":contactController.text,
          "email":emailController.text,
          "gender":gender,
          "city":cityController.text,
          "capacity":capacity,
          "about":aboutController.text,
          "gallery":gallery,
          "premium":false,
          "image":urlImage,
          "timeslots":timings,
          "status":0,
          "latitude":latitude,
          "longitude":longitude,
        });
        for(int i=0;i<services.length;i++){
          await FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid.toString()).collection("service").add({
              "name":services[i]["name"],
              "category":services[i]["category"],
             "price":services[i]["price"],
              "duration":services[i]["duration"]
          });
        }
        for(int j=0;j<packages.length;j++){
          await FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid.toString()).collection("package").add({
            "name":packages[j]["name"],
            "desc":packages[j]["desc"],
            "price":packages[j]["price"],
            "duration":packages[j]["duration"],
            "image":packImage[j],
            "services":packages[j]["services"]
          });
        }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('step', true);
        setState(() {
          loading=false;
        });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => OwnerDashedBoard()),
              (route) => false);

      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        width: 80.w,
        decoration: BoxDecoration(
            color: BHColorPrimary, borderRadius: BorderRadius.circular(5)),
        child:
            Text("Submit", style: TextStyle(color: whiteColor, fontSize: 15.w)),
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return GestureDetector(
        onTap: () async {
          // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
          else{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("owner", false);
            FirebaseAuth.instance.signOut();
            onPrevBtn(context);
          }
        },
        child: prevNext("Prev"));
  }

  Widget handleProcess(screen) {

    if (screen == 0) {
      return Visibility(
        visible: activeStep == 0,
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: SingleChildScrollView(
            child: Form(
              key: formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 140.h,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Text(
                                    'Choose Profile Picture',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  20.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          IconButton(
                                            iconSize: 70,
                                            icon: const Icon(Icons.camera),
                                            onPressed: () async {
                                              await pickImage(
                                                  ImageSource.camera, image2);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Text('Camera')
                                        ],
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            iconSize: 70,
                                            icon: const Icon(Icons.image),
                                            onPressed: () async {
                                              File? img;
                                              image2 = await pickImage(
                                                  ImageSource.gallery, img);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Text('Gallery'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
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
                  Center(
                      child: Container(
                    margin: EdgeInsets.only(top: 8.h),
                    child: Text(
                      "Add Information",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  )),

                  labelText("Salon For"),
                  10.height,
                  Center(
                    child: ToggleSwitch(
                      minWidth: 90.w,
                      initialLabelIndex: gender,
                      cornerRadius: 10.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 3,
                      labels: ['Male', 'Female',"Both"],
                      icons: [Icons.male, Icons.female,Icons.transgender],
                      activeBgColors: [[Colors.blue],[Colors.pink],[Colors.green]],
                      onToggle: (index) {
                        gender = index!;
                      },
                    ),
                  ),
                  5.height,
                  labelText("*Complete Address"),
                  5.height,
                  multiLineForm(controller: addressController,lines: 2),
                  5.height,
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
                  // labelText("*Pincode"),
                  // Container(
                  //   margin: EdgeInsets.only(left: 20.w, right: 20.w),
                  //   child: TextFormField(
                  //     controller: pincodeController,
                  //     keyboardType: TextInputType.number,
                  //     decoration: InputDecoration(
                  //       fillColor: Colors.grey.shade200,
                  //       isDense: true,
                  //       contentPadding: EdgeInsets.symmetric(
                  //           horizontal: 10.w, vertical: 7.h),
                  //       hintStyle: TextStyle(
                  //         fontSize: 15,
                  //         color: Color(0xff8d8d8d),
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(15),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       prefixIconColor: Color(0xff4f4f4f),
                  //       focusedBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: BHAppDividerColor)),
                  //       enabledBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: BHAppDividerColor)),
                  //     ),
                  //     onChanged: (value) async {
                  //       print(value);
                  //       if (value.length == 6) {
                  //         FocusManager.instance.primaryFocus?.unfocus();
                  //         await _getLocations(value);
                  //         const snackBar = SnackBar(
                  //           content: Text('Please Wait'),
                  //           duration: Duration(seconds: 1),
                  //         );
                  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  //         final Locations location = locations.elementAt(1);
                  //         setState(() {
                  //           cityController.text =
                  //               location.district.split(' ')[0].trim();
                  //         });
                  //       }
                  //     },
                  //     onEditingComplete: (){
                  //
                  //     },
                  //   ),
                  // ),
                  // 5.height,

                  // labelText("*City"),
                  // forms(controller: cityController, choice: "Alpha"),

                  5.height,
                  labelText("*Select Capacity of Salon"),
                  Container(
                    height: 40.h,
                    margin: EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w),
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      hint: Text(
                        capacity==""?'Capacity':capacity,
                        style: TextStyle(fontSize: 14),
                      ),
                      items: Capacity.map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                      onChanged: (value) {
                        setState(() {
                          capacity = value.toString();
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          capacity = value.toString();
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 60,
                        padding: EdgeInsets.only(left: 0, right: 10),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 150.h,
                      ),
                    ),
                  ),
                  5.height,
                  labelText("Email Address"),
                  forms(controller: emailController, choice: "alpha"),
                  5.height,
                  labelText("About Salon"),
                  multiLineForm(controller: aboutController, lines: 2),
                  24.height,
                  // labelText("State"),
                  // forms(controller: stateController, choice: "Alpha"),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else if (screen == 1) {
      return Visibility(
        visible: activeStep == 1,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: selectedImages.isEmpty
                  ? Center(
                      child: Text("Add Images (max. 3)",
                          style: TextStyle(
                              fontSize: 20.w, fontWeight: FontWeight.bold)))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 130.w,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h),
                      itemCount: selectedImages.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImages[index],
                                  width: 130.w,
                                  height: 130.h,
                                  fit: BoxFit.cover,
                                )),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImages.removeWhere((element) =>
                                          element == selectedImages[index]);
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25.w,
                                  )),
                            )
                          ],
                        );
                      }),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  getImages();
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.h, right: 10.w),
                  width: 50.w,
                  height: 43.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: BHColorPrimary),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else if (screen == 2) {
      return Visibility(
        visible: activeStep == 2,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  Center(
                      child: Container(
                    margin: EdgeInsets.only(top: 5.h),
                    child: Text(
                      "Add Services",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  )),
                  10.height,
                  BoxForms(serviceName, "Service Name", "alpha"),
                  15.height,
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
                  BoxForms(servicePrice, "Service Price", "number"),
                  15.height,
                  BoxForms(
                      serviceDuration, "Service Duration (in min)", "number"),
                  10.height,
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: BHColorPrimary,
                      ),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final isValid = formGlobalKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          else if (selectedValue == "" ) {
                            Fluttertoast.showToast(
                                msg: "Please Choose a category",
                                timeInSecForIosWeb: 3);
                          } else {
                            setState(() {
                              services.add({
                                "name": serviceName.text,
                                "category": selectedValue,
                                "price": servicePrice.text,
                                "duration": serviceDuration.text,
                                "image": image2
                              });
                              serviceName.clear();
                              selectedValue = "";
                              servicePrice.clear();
                              serviceDuration.clear();
                            });
                            Fluttertoast.showToast(
                                msg: "Service Added Successfully",
                                timeInSecForIosWeb: 4);
                          }
                        },
                        child: Text("Add Service",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  ListView.builder(
                      itemCount: services.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Card(
                          margin:
                              EdgeInsets.only(top: 7.h, left: 5.w, right: 5.w),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 5.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name-${services[index]["name"]}",
                                        style: TextStyle(
                                            fontSize: 16.w,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      1.height,
                                      Text(
                                        "Category-${services[index]["category"]}",
                                        style: TextStyle(
                                            fontSize: 13.w, color: Colors.grey),
                                      ),
                                      1.height,
                                      Text(
                                        "Price- \u{20B9} ${services[index]["price"]}",
                                        style: TextStyle(
                                            fontSize: 14.w,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      1.height,
                                      Text(
                                        "Duration- ${services[index]["duration"]}min",
                                        style: TextStyle(
                                            fontSize: 13.w, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        services.removeWhere((element) =>
                                            element["name"] ==
                                            services[index]["name"]);
                                      });
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 25.w,
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
                  15.height,
                ],
              ),
            ),
          ),
        ),
      );
    } else if (screen == 3) {
      if(packageEntry.length<services.length){
        packageEntry.clear();
        for(int i=0;i<services.length;i++){
          packageEntry.add(services[i]["name"]);
        }
      }
      return Visibility(
        visible: activeStep == 3,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Form(
              key: formGlobalKey2,
              child: Column(
                children: [
                  10.height,
                  Center(
                      child: Container(
                    child: Text(
                      "Add Packages",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  )),
                  10.height,
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        File? imgg;
                        image3 = await pickImage(ImageSource.gallery, imgg);
                      },
                      child: image3 == null
                          ? Container(
                              height: 90.h,
                              alignment: Alignment.center,
                              width: 110.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black12),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 40.w,
                              ),
                            )
                          : Container(
                              height: 90.h,
                              width: 300.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(image3!, fit: BoxFit.cover),
                              ),
                            ),
                    ),
                  ),
                  10.height,
                  BoxForms(packageName, "Package Name", "alpha"),
                  10.height,
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                        isDense: true,
                        dropdownStyleData: DropdownStyleData(maxHeight: 300.h),
                        isExpanded: true,
                        hint: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Select Services',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                        items: packageEntry.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            //disable default onTap to avoid closing menu when selecting an item
                            enabled: false,
                            child: StatefulBuilder(
                              builder: (context, menuSetState) {
                                final _isSelected = selectedItems.contains(item);
                                return InkWell(
                                  onTap: () {
                                    _isSelected
                                        ? selectedItems.remove(item)
                                        : selectedItems.add(item);
                                    //This rebuilds the StatefulWidget to update the button's text
                                    setState(() {});
                                    //This rebuilds the dropdownMenu Widget to update the check mark
                                    menuSetState(() {});
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Row(
                                      children: [
                                        _isSelected
                                            ? const Icon(Icons.check_box_outlined)
                                            : const Icon(
                                                Icons.check_box_outline_blank),
                                        const SizedBox(width: 16),
                                        Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                        value: selectedItems.isEmpty ? null : selectedItems.last,
                        onChanged: (value) {},
                        selectedItemBuilder: (context) {
                          return packageEntry.map(
                            (item) {
                              return Container(
                                alignment: AlignmentDirectional.centerStart,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  selectedItems.join(', '),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              );
                            },
                          ).toList();
                        },
                        buttonStyleData: ButtonStyleData(
                            height: 45.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            width: context.width(),
                            padding: EdgeInsets.only(right: 10, left: 10)),
                        menuItemStyleData: MenuItemStyleData(
                          padding: EdgeInsets.zero,
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: textEditingController,
                          searchInnerWidgetHeight: 50.h,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: EdgeInsets.only(
                                top: 10.h, left: 10.w, right: 10.w),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search for an item...',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return (item.value.toString().contains(searchValue));
                          },
                        ),
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            textEditingController.clear();
                          }
                        }),
                  ),
                  15.height,
                  BoxForms(packagePrice, "Package Price", "number"),
                  15.height,
                  BoxForms(
                      packageDuration, "Package Duration (in min)", "number"),
                  15.height,
                  TextFormField(
                    controller: packageDescription,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      fillColor: Colors.grey.shade200,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      hintText: "Package Description",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xff8d8d8d),
                      ),
                      prefixIconColor: Color(0xff4f4f4f),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: BHColorPrimary)),
                    ),
                    validator: (value) {
                      if (value=="") {
                        return 'Field Cannot be Empty!';
                      }
                      return null;
                    },
                  ),
                  10.height,
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: BHColorPrimary,
                      ),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextButton(
                        onPressed: () {
                          final isValid = formGlobalKey2.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          else if (selectedItems.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please Choose Services",
                                timeInSecForIosWeb: 4);
                          }
                          else if(image3==null){
                            Fluttertoast.showToast(
                                msg: "Please Enter Package Image",
                                timeInSecForIosWeb: 4);
                          }

                          else {
                            List itemss = [];
                            for (int i = 0; i < selectedItems.length; i++) {
                              itemss.add(selectedItems[i]);
                            }
                            setState(() {
                              packages.add({
                                "name": packageName.text,
                                "services": itemss,
                                "price": packagePrice.text,
                                "duration": packageDuration.text,
                                "desc": packageDescription.text,
                                "image": image3
                              });
                              packageName.clear();
                              packagePrice.clear();
                              packageDuration.clear();
                              packageDescription.clear();
                              image3 = null;
                              selectedItems.clear();
                            });
                          }
                        },
                        child: Text("Add Package",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  ListView.builder(
                      itemCount: packages.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Card(
                          margin:
                              EdgeInsets.only(top: 12.h, left: 5.w, right: 5.w),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 9.h, horizontal: 10.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        packages[index]["image"],
                                        width: 80.w,
                                        height: 70.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    10.width,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          packages[index]["name"] ,
                                          style: TextStyle(
                                              fontSize: 13.w,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: packages[index]["services"]
                                              .map<Widget>((e) => Text(
                                                    e.toString() + "\n",
                                                    style: TextStyle(
                                                        fontSize: 11.w,
                                                        color: Colors.grey),
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text("\u{20B9} " +
                                            packages[index]["price"]),
                                        10.height,
                                        Text(packages[index]['duration'] + "min")
                                      ],
                                    ),
                                    15.width,
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            packages.removeWhere((element) =>
                                                element["name"] ==
                                                packages[index]["name"]);
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 25.w,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (screen == 4) {
      if(timings.isEmpty){
        for(int j=0;j<days.length;j++){
          timings.add({"title":days[j],"timing":"10:00AM - 8:00PM"});
        }
      }
      return Visibility(
        visible: activeStep == 4,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    child: Text(
                      "Choose Salon Timings",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.w,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                    ),
                  )),
              8.height,
              ListView.builder(
                  itemCount: timings.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                            Text(
                              timings[index]['title'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.w),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _showDialog(index);
                                },
                                child: Icon(
                                  Icons.edit_note_sharp,
                                  size: 30.w,
                                  color: Colors.blue,
                                )),
                      ],
                          ),
                          Text(
                            timings[index]["timing"],
                            style: TextStyle(
                                fontSize: 15.w,
                                color: BHColorPrimary,
                                fontWeight: FontWeight.bold),
                          ),
                          8.height,
                          GestureDetector(
                            onTap: (){
                                setState(() {
                                  timings[index]['timing'] = "Closed";
                                });
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:Colors.red,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),

                                  child: Text("Close ",
                                      style: TextStyle(color: Colors.white, fontSize: 14)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              10.height,
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  // bool status = false;
  Future<void> _showDialog(int index) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            contentTextStyle: TextStyle(color: BHAppTextColorSecondary),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
            title: Center(
              child: Text(timings[index]["title"],
                  style: TextStyle(fontSize: 16, color: BHAppTextColorPrimary)),
            ),
            content: Container(
              height: 150.h,
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: Center(
                          child: TextFormField(
                            controller: timeinput,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                                border: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15)),
                                prefixIcon: Icon(Icons.access_time_outlined),
                                suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: BHColorPrimary)),
                                hintText: "Open Time"),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay(hour: 9, minute: 00),
                                context: context,
                              );
                              if (pickedTime != null) {
                                DateTime tempDate = DateFormat("hh:mm").parse(
                                    pickedTime.hour.toString() +
                                        ":" +
                                        pickedTime.minute.toString());
                                var dateFormat = DateFormat("h:mm a");
                                final time = dateFormat.format(tempDate);
                                setState(() {
                                  timeinput.text = time;
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                          ))),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: Center(
                          child: TextFormField(
                            controller: timeoutput,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                                border: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15)),
                                prefixIcon: Icon(Icons.access_time_outlined),
                                suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: BHColorPrimary)),
                                hintText: "Closing Time"),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay(hour: 9, minute: 00),
                                context: context,
                              );
                              if (pickedTime != null) {
                                DateTime tempDate = DateFormat("hh:mm").parse(
                                    pickedTime.hour.toString() +
                                        ":" +
                                        pickedTime.minute.toString());
                                var dateFormat = DateFormat("h:mm a");
                                final time = dateFormat.format(tempDate);
                                setState(() {
                                  timeoutput.text = time;
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                          ))),

                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: Text("Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
              10.width,
              GestureDetector(
                onTap: (){
                  setState(() {
                    if(timeinput.text.isEmpty ||timeoutput.text.isEmpty ){
                      Fluttertoast.showToast(msg: "Enter Correct Timings");
                    }
                    else{
                      timings[index]['timing'] = timeinput.text+" - " +timeoutput.text;
                      timeinput.clear();
                      timeoutput.clear();
                      Navigator.of(context).pop();

                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color:BHColorPrimary,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                  margin: EdgeInsets.only(bottom: 10.h),

                  child: Text("Change Slot",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          );
        });
  }
  getCate()async{
    await FirebaseFirestore.instance.collection("category").get().then((value){
      value.docs.forEach((element) {
        Items.add(element["name"]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCate();
  }
}
