import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon/hairSalon/screens/load_widget.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';

class BHPrivacy extends StatelessWidget {
  const BHPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
        backgroundColor: BHColorPrimary,
      ),
      body: FutureBuilder(
          future: rootBundle.loadString("images/hairSalon/privacy.md"),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Markdown(data: snapshot.data!);
            }

            return Center(
              child: BHLoading(),
            );
          }),
    );
  }
}
