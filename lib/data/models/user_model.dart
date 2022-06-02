import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? imageUrl;
  String? phoneNumber;
  DateTime? date;

  UserModel(
      {this.id,
      this.email,
      this.name,
      this.imageUrl,
      this.phoneNumber,
      this.date});

  UserModel.fromJson(DocumentSnapshot snapshot) {
    id = snapshot['uid'];
    name = snapshot['name'];
    email = snapshot['email'];
    imageUrl = snapshot['photoUrl'];
    //phoneNumber = snapshot['phoneNumber'];
    // date = snapshot['date'];
  }
}
