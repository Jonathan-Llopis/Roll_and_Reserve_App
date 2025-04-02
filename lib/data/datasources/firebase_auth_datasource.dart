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
    UserCredential userCredentials =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return UserModel.fromUserCredential(userCredentials);
  }

  /// Signs up a user with the given email and password.
  ///
  /// Returns a [UserModel] with the signed up user's data.
  ///
  /// Throws a [FirebaseAuthException] if the sign up fails.
  Future<UserModel> signUp(String email, String password) async {
    UserCredential userCredentials = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return UserModel.fromUserCredential(userCredentials);
  }

  /// Logs out the currently signed-in user from Firebase.
  ///
  /// This method will terminate the user's session and sign them out
  /// of the application. It does not return any value and completes
  /// once the sign-out process is finished.

  Future<void> logout() async {
    await auth.signOut();
  }

  /// Returns the email of the currently signed-in user, or null if there is
  /// no user signed in.
  String? getCurrentUser() {
    final user = auth.currentUser;
    return user?.email;
  }

  /// Signs in a user with Google authentication.
  ///
  /// On the web, this uses the Google Sign In popup. On mobile, this uses the
  /// Google Sign In SDK to sign in the user.
  ///
  /// Returns a [UserModel] with the signed in user's data.
  ///
  /// Throws a [FirebaseAuthException] if the sign in fails.
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
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut(); // Ensure the user can choose the account
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

        userCredentials = await auth.signInWithCredential(credential);
      }
      return UserModel.fromUserCredential(userCredentials);
    } catch (e) {
      rethrow;
    }
  }

  /// Sends a password reset email to the given email address.
  ///
  /// This method will send an email to the user with a link to reset their
  /// password. The user will not be signed out of their current session.
  ///
  /// Throws a [FirebaseAuthException] if the email address is invalid or if
  /// there is no user with the given email address.
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  /// Validates a user's password against the stored password.
  ///
  /// Returns true if the password is valid, false otherwise.
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
  /// Updates the password of the currently signed in user.
  ///
  /// This method should only be called when the user is signed in.
  ///
  /// Throws a [FirebaseAuthException] if the user is not signed in.
  Future<void> updatePassword(String password) async {
    var firebaseUser = auth.currentUser;
    firebaseUser?.updatePassword(password);
  }
}
