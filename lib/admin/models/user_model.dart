
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String? name;
  final String? phone;
  final String? image;
  final String? email;
  User(
      {this.id,
        this.name,
        this.phone,
        this.image,
        this.email,
       });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'image': image,
      'email': email,
    };
  }

  factory User.fromDocumentSnapshot(DocumentSnapshot doc){
    return User(
        id: doc.id,
        name: doc.data().toString().contains('name') ? doc.get('name') : '',
        phone: doc.data().toString().contains('phone') ? doc.get('phone') : "",
        image: doc.data().toString().contains('image') ? doc.get('image') : '',
        email: doc.data().toString().contains('email') ? doc.get('email') : '',

    );
  }
}