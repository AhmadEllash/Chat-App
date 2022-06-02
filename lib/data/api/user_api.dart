import 'package:cloud_firestore/cloud_firestore.dart';

class UserApi {
  Future searchUser(String name) async {
    final userFounded = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .get();

    return userFounded.docs;
  }

  Future getUserById(String uid) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    return user.docs;
  }
}
