import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth auth;

  FirebaseAuthDataSource({required this.auth});

  Future<UserModel> signIn(String email, String password) async {
    UserCredential userCredentials =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return UserModel.fromUserCredential(userCredentials);
  }

  Future<UserModel> signUp(String email, String password) async {
    UserCredential userCredentials = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return UserModel.fromUserCredential(userCredentials);
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  String? getCurrentUser() {
    final user = auth.currentUser;
    return user?.email;
  }

  Future<UserModel> signInWithGoogle() async {
    UserCredential userCredentials;
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

        userCredentials =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          throw FirebaseAuthException(
              code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
        }
        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCredentials =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }
      return UserModel.fromUserCredential(userCredentials);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

Future<bool> validatePassword(String password, String email) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException {
    return false;
  } catch (e) {
    return false;
  }
}
  Future<void> updatePassword(String password) async {
    var firebaseUser = auth.currentUser;
    firebaseUser?.updatePassword(password);
  }
}
