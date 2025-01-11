import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsersDatasource {
  Future<void> registerUser(String email, String nombre, String id) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(id);
    await users.set({'email': email, 'name': nombre, 'rol': 2, 'id': id});
  }

  Future<void> updateUserInfo(String nombre, String id, int role) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(id);
    await users.update({'name': nombre, 'rol': role,});
  }


  Future<bool> isEmailUsed(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot = await users.where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isNameUsed(String name) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot = await users.where('name', isEqualTo: name).get();
    if (snapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
