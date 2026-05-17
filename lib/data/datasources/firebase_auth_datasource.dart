import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth auth;

  FirebaseAuthDataSource({required this.auth});

  /// Signs in a user with the given email and password.
  ///
  /// Returns a [UserModel] with the signed in user's data.
  ///
  /// Throws a [FirebaseAuthException] if the sign in fails.
  Future<UserModel> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromUserCredential(userCredential);
    } catch (e) {
      rethrow;
    }
  }

  /// Signs up a user with the given name, username, email and password.
  ///
  /// Returns a [UserModel] with the signed up user's data.
  ///
  /// Throws a [FirebaseAuthException] if the sign up fails.
  Future<UserModel> signUp(
    String name,
    String username,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      return UserModel.fromUserCredential(userCredential);
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out the current user.
  ///
  /// Throws a [FirebaseAuthException] if the sign out fails.
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Signs in a user with Google.
  ///
  /// Returns a [UserModel] with the signed in user's data.
  ///
  /// Throws a [FirebaseAuthException] if the sign in fails.
  Future<UserModel> signInWithGoogle() async {
    try {
      late UserCredential userCredentials;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

        userCredentials =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
        );
        await googleSignIn.signOut(); // Ensure the user can choose the account
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        userCredentials = await auth.signInWithCredential(credential);
      }
      return UserModel.fromUserCredential(userCredentials);
    } catch (e) {
      rethrow;
    }
  }

  /// Resets the password for the given email address.
  ///
  /// Throws a [FirebaseAuthException] if the email address is invalid or if
  /// there is no user with the given email address.
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  /// Updates the password of the current user.
  Future<void> updatePassword(String password) async {
    try {
      await auth.currentUser!.updatePassword(password);
    } catch (e) {
      rethrow;
    }
  }

  /// Validates the provided password for the currently signed-in user.
  Future<bool> validatePassword(String password, String email) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await auth.currentUser!.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }
}
