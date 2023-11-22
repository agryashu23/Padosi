import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

import 'package:nb_utils/nb_utils.dart';
import 'dart:io';

import '../../hairSalon/screens/load_widget.dart';
import '../../hairSalon/utils/BHColors.dart';

class AddOwnerPackage extends StatefulWidget {
  const AddOwnerPackage({Key? key}) : super(key: key);

  @override
  State<AddOwnerPackage> createState() => _AddOwnerPackageState();
}

class _AddOwnerPackageState extends State<AddOwnerPackage> {
  List Services=[];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid).collection("service").get().then((value) {
      value.docs.forEach((element) {
        Services.add(element["name"]);
      });
    });
  }
  TextEditingController packageName = TextEditingController();
  TextEditingController packagePrice = TextEditingController();
  TextEditingController packageDuration = TextEditingController();
  TextEditingController packageDescription = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  File? image3;
  bool loading=false;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        image3 = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  firebase_storage.Reference? ref;
  String urlImage = "";
  CollectionReference? imgRef;
  Future uploadFiles() async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('owners/${Path.basename(image3!.path)}');
    await ref!.putFile(image3!).whenComplete(() async {
      await ref!.getDownloadURL().then((value) async {
        imgRef?.add({"url": value});
        setState(() {
          urlImage = value;
        });
      });
    });
  }
  List<String> selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Package"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: loading?BHLoading():Container(
        padding: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  await pickImage();
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
            20.height,
            TextFormField(
              controller: packageName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Package Name",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            15.height,
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isDense: true,
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 350.h
                ),
                isExpanded:true,
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
                items: Services.map((item) {
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
                            padding:  EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                _isSelected
                                    ? const Icon(Icons.check_box_outlined)
                                    : const Icon(Icons.check_box_outline_blank),
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
                  return Services.map(
                        (item) {
                      return Container(
                        alignment: AlignmentDirectional.centerStart,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    borderRadius: BorderRadius.circular(5)
                  ),
                  width: context.width(),
                  padding: EdgeInsets.only(right: 10,left: 10)
                ),
                menuItemStyleData:  MenuItemStyleData(
                  padding: EdgeInsets.zero,
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50.h,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w),
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
                  }
              ),
            ),
            15.height,
            TextFormField(
              controller: packagePrice,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Package Price",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            15.height,
            TextFormField(
              controller: packageDuration,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Package Duration",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            15.height,
            TextFormField(
              controller: packageDescription,
              keyboardType: TextInputType.text,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                ),
                fillColor: Colors.grey.shade200,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                hintText: "Package Description",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xff8d8d8d),
                ),
                prefixIconColor: Color(0xff4f4f4f),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BHColorPrimary)),
              ),
            ),
            20.height,
            Center(
              child: Container(
                color: BHColorPrimary,
                width: MediaQuery.of(context).size.width*0.45,
                child: TextButton(
                  onPressed: () async{
                    if(packageName.text.isEmpty || packageDescription.text.isEmpty || packagePrice.text.isEmpty || packageDuration.text.isEmpty || selectedItems.isEmpty ||
                        image3 == null){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.tealAccent,
                        duration: Duration(seconds: 2),
                        content: Text("Please enter all fields"),));
                    }
                    else{
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        loading=true;
                      });
                      await uploadFiles();
                      await FirebaseFirestore.instance.collection("services").doc(FirebaseAuth.instance.currentUser!.uid).collection("package").add({
                        "name": packageName.text,
                        "services": selectedItems,
                        "price": packagePrice.text,
                        "duration": packageDuration.text,
                        "desc": packageDescription.text,
                        "image": urlImage
                      });
                      setState(() {
                        packageName.clear();
                        packagePrice.clear();
                        packageDuration.clear();
                        packageDescription.clear();
                        image3 = null;
                        urlImage="";
                        selectedItems.clear();
                        loading=false;
                      });
                      Fluttertoast.showToast(msg: "Package added successfully");
                      Navigator.of(context).pop();
                    }
                    // BHDashedBoardScreen().launch(context);
                  },
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: Text("Add Package", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
