import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsersDatasource {
  /// Registers a user in the Firestore database.
  ///
  /// The user is registered with the given [email], [nombre] and [id].
  /// The user is given the 'rol' 2, which is the default role for a user who is not an admin.
  /// The user is also given a default list of notifications, which is empty, and 'isFirstTime' set to true.
  Future<void> registerUser(String email, String nombre, String id) async {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Users').doc(id);
    await users.set({'email': email, 'name': nombre, 'rol': 2, 'id': id,  'notifications': [], 'isFirstTime': true});
  }
  /// Updates the information of a user in the Firestore database.
  ///
  /// The user is identified by its [id].
  /// The user is updated with the given [nombre], [role] and [notifications].
  /// The 'isFirstTime' field is not touched.
  Future<void> updateUserInfo(String nombre, String id, int role, List<int> notifications) async {
    DocumentReference users =

        FirebaseFirestore.instance.collection('Users').doc(id);
    await users.update({'name': nombre, 'rol': role, 'notifications': notifications });
  }

  /// Retrieves the list of notifications for a user from the Firestore database.
  ///
  /// The user is identified by their [id].
  /// Returns a list of integers representing the notifications.
  /// If the user does not exist, an empty list is returned.

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

  /// Checks if the user with the given [id] is in their first time in the app.
  ///
  /// If the user does not exist, it is considered to be their first time.
  /// If the user exists, the value of 'isFirstTime' is returned.
  /// If the user exists but 'isFirstTime' does not exist, true is returned.
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


  /// Updates a field in a user document in the Firestore database.
  ///
  /// The user is identified by its [id].
  /// The field to update is identified by [fieldName].
  /// The value of the field is set to [value].
  Future<void> saveUserField(String id, String fieldName, dynamic value) async {
    DocumentReference users =

        FirebaseFirestore.instance.collection('Users').doc(id);
    await users.update({fieldName: value});
  }


  /// Checks if an email is already used in the Firestore database.
  ///
  /// Queries the 'Users' collection to see if any document has a matching [email].
  /// Returns `true` if a document with the provided email exists, otherwise `false`.

  Future<bool> isEmailUsed(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot = await users.where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  /// Checks if a username is already used in the Firestore database.
  ///
  /// Queries the 'Users' collection to see if any document has a matching [name].
  /// Returns `true` if a document with the provided name exists, otherwise `false`.
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
