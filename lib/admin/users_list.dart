import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salon/admin/models/user_model.dart';
import 'package:salon/hairSalon/utils/BHColors.dart';


class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

  Future <List<User>>getUser()async{
    final snapshot = await FirebaseFirestore.instance.collection("users").get();
    final userData = snapshot.docs.map((e)=> User.fromDocumentSnapshot(e)).toList();
    print(userData);
    return userData;
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
                child: Text("Delete this User",
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
                    await FirebaseFirestore.instance.collection("users").doc(id).delete();
                    setState(() {
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
          title: Text("Users List"),
          centerTitle: true,
          backgroundColor: BHColorPrimary,
        ),
        body: FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child:CircularProgressIndicator());
              }
              else if(!snapshot.hasData){
                return Center(child: Text("No data found",style: TextStyle(fontSize: 18.w,fontWeight:FontWeight.bold),),);
              }
              else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                     return Card(
                       elevation: 3,
                       child: Container(
                         margin: EdgeInsets.only(
                             top: 5.h, left: 5.w, right: 5.w),
                         padding: EdgeInsets.symmetric(
                             horizontal: 10.w, vertical: 5.h),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             snapshot.data![index].image == "" ? Container(height: 50.h,width: 60.w,) : Container(
                                 height: 50.h, width: 60.w,
                                 child: Image.network(snapshot.data![index].image.toString(), fit: BoxFit.cover,)),
                             20.width,
                             SizedBox(
                               width: 190.w,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(snapshot.data![index].name.toString()),
                                   10.height,
                                   Text(snapshot.data![index].phone.toString()),
                                   10.height,
                                   Text(snapshot.data![index].email.toString()),
                                 ],
                               ),
                             ),
                             GestureDetector(
                               onTap: (){
                                 _showDialog(snapshot.data![index].id.toString());
                               },
                               child: Icon(
                                 Icons.delete, color: Colors.red, size: 30.w,),
                             ),
                             5.height,
                           ],
                         ),
                       ),
                     );
                    }
                );
              }
            }
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }
}