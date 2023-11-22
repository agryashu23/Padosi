import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/Admin_Salons/show_salons.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

import '../../hairSalon/utils/cities.dart';

class ChooseCity extends StatefulWidget {
  const ChooseCity({Key? key}) : super(key: key);

  @override
  State<ChooseCity> createState() => _ChooseCityState();
}

class _ChooseCityState extends State<ChooseCity> {
  String cityValue="Sheopur";
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose City"),
        centerTitle: true,
        backgroundColor: BHColorPrimary,
      ),
      body: Padding(
        padding:EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: cities
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
                    .toList(),
                value: cityValue,
                onChanged: (value) {
                  setState(() {
                    cityValue = value as String;
                  });
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
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 300.h
                ),
                menuItemStyleData:  MenuItemStyleData(
                  padding: EdgeInsets.only(left: 10.w),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      textCapitalization: TextCapitalization.words,
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
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            ),
            80.height,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: BHColorPrimary,
              ),
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () async{
                 ShowSalons(city:cityValue).launch(context);
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text("View Salons", style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
