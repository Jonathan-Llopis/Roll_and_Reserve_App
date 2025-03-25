import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsersDatasource {
  Future<void> registerUser(String email, String nombre, String id) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(id);
    await users.set({'email': email, 'name': nombre, 'rol': 2, 'id': id,  'notifications': [], 'isFirstTime': true});
  }

  Future<void> updateUserInfo(String nombre, String id, int role, List<int> notifications) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(id);
    await users.update({'name': nombre, 'rol': role, 'notifications': notifications });
  }

  Future<List<int>> getUserNotifications(String id) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(id);
    DocumentSnapshot snapshot = await users.get();
    if (snapshot.exists) {
      return List<int>.from(snapshot['notifications']);
    } else {
      return [];
    }
  }

  Future<bool> isFirstTime(String id) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(id);
    DocumentSnapshot snapshot = await users.get();
    if (snapshot.exists) {
      return snapshot['isFirstTime'] ?? true;
    } else {
      return true;
    }
  }

  Future<void> saveUserField(String id, String fieldName, dynamic value) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(id);
    await users.update({fieldName: value});
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
