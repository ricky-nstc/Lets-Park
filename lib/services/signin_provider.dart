// ignore_for_file: empty_catches, unused_catch_clause

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:lets_park/main.dart';
import 'package:lets_park/models/user_data.dart';
import 'package:lets_park/screens/loading_screens/logging_in_screen.dart';
import 'package:lets_park/screens/popups/notice_dialog.dart';
import 'package:lets_park/services/user_services.dart';

import '../globals/globals.dart' as globals;

class SignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleUser;
  GoogleSignInAccount get getGoogleUser => _googleUser!;

  Future signinWithEmailAndPass(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      _showLoading(context);
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      notifyListeners();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      await _showDialog(
        context,
        "assets/logo/lets-park-logo.png",
        "Login failed! Please make sure to enter correct account credentials.",
      );
    }
  }

  Future signUpWithEmailandPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _showLoading(context);
    try {
      final UserCredential authResult = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser!.updateDisplayName(name);
      await _auth.currentUser!.updatePhotoURL(
          "https://cdn4.iconfinder.com/data/icons/user-people-2/48/5-512.png");
      checkIsNewUser(authResult);
      notifyListeners();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'invalid-email') {
        await _showDialog(
          context,
          "assets/logo/lets-park-logo.png",
          "The email is invalid. Please try creating an account with a valid email.",
        );
      } else if (e.code == 'email-already-in-use') {
        await _showDialog(
          context,
          "assets/logo/lets-park-logo.png",
          "Looks like the email you entered is already link to another account. Please try different email.",
        );
      } else {
        await _showDialog(
          context,
          "assets/logo/lets-park-logo.png",
          "Something went wrong. Please try again.",
        );
      }
    }
  }

  Future googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;
      showDialog(context: context, builder: (context) => const LoggingIn());
      _googleUser = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      checkIsNewUser(
        authResult,
      );
    } on Exception catch (e) {
    } finally {
      notifyListeners();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future loginWithFacebook(BuildContext context) async {
    _showLoading(context);
    try {
      final result = await FacebookAuth.instance.login();
      if (result.accessToken != null) {
        final fbUserCredentials =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final UserCredential authResult =
            await _auth.signInWithCredential(fbUserCredentials);
        checkIsNewUser(
          authResult,
        );
      } else {
        await _showDialog(
          context,
          "assets/logo/lets-park-logo.png",
          "Something went wrong. Try logging in instead.",
        );
      }
    } on Exception catch (e) {
      await _showDialog(
        context,
        "assets/logo/lets-park-logo.png",
        "Looks like the email linked in your Facebook account is already link to another account. Try logging in instead.",
      );
    } finally {
      notifyListeners();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future logout(BuildContext context) async {
    _showLoading(context);

    try {
      await FacebookAuth.instance.logOut();
    } on Exception catch (e) {}
    try {
      await googleSignIn.disconnect();
    } on Exception catch (e) {}
    await _auth.signOut();
    globals.inProgressParkings = [];
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future _showDialog(
    BuildContext context,
    String image,
    String message,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return (NoticeDialog(
          imageLink: image,
          message: message,
        ));
      },
    );
  }

  void checkIsNewUser(UserCredential authResult) {
    if (authResult.additionalUserInfo!.isNewUser) {
      if (authResult.user != null) {
        UserServices.registerNewUserData();
      }
    }
  }

  static Map<String, dynamic>? parseJwt(String token) {
    // validate token
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    // retrieve token payload
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    // convert to Map
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }

  static Future<UserData> getUserData(String docId) async {
    UserData data = UserData();
    await FirebaseFirestore.instance
        .collection("user-data")
        .doc(docId)
        .get()
        .then((userData) {
      data = UserData.fromJson(userData.data()!);
    });

    return data;
  }
}
