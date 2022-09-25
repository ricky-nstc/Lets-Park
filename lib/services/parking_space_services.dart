// ignore_for_file: empty_catches, avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lets_park/globals/globals.dart' as globals;
import 'package:lets_park/main.dart';
import 'package:lets_park/models/parking.dart';
import 'package:lets_park/models/parking_space.dart';
import 'package:lets_park/models/review.dart';
import 'package:lets_park/screens/popups/notice_dialog.dart';

class ParkingSpaceServices {
  static final _parkingSpaces =
      FirebaseFirestore.instance.collection('parking-spaces');

  static void updateParkingSpaceData(
    ParkingSpace space,
    Parking parking,
  ) async {
    final docUser = _parkingSpaces
        .doc(space.getSpaceId)
        .collection("parking-sessions")
        .doc(parking.getParkingId);

    await docUser.set(parking.toJson());
  }

  static Future<bool> isParkingSpaceAvailableAtTimeRange(
    String? id,
    int? arrival,
    int? departure,
  ) async {
    bool isAvailable = false;
    DateTime selectedArrival = _getDateTimeFromMillisecondsFromEpoch(arrival!);
    DateTime selectedDeparture =
        _getDateTimeFromMillisecondsFromEpoch(departure!);
    List<Parking> sessions = [];
    await FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(id)
        .collection("parking-sessions")
        .get()
        .then((value) => value.docs.forEach((element) {
              sessions.add(Parking.fromJson(element.data()));
            }));
    if (sessions.isNotEmpty) {
      sessions.sort((sessionA, sessionB) {
        int sessionTimeA = sessionA.getArrival! + sessionA.getDeparture!;
        int sessionTimeB = sessionB.getArrival! + sessionB.getDeparture!;

        var r = sessionTimeA.compareTo(sessionTimeB);
        if (r != 0) return r;
        return sessionTimeA.compareTo(sessionTimeB);
      });

      for (int i = 0; i < sessions.length; i++) {
        DateTime arrival =
            _getDateTimeFromMillisecondsFromEpoch(sessions[i].getArrival!);
        DateTime departure =
            _getDateTimeFromMillisecondsFromEpoch(sessions[i].getDeparture!);

        if (selectedArrival.compareTo(arrival) == 0 &&
            selectedDeparture.compareTo(departure) == 0) {
          isAvailable = false;
          break;
        } else if (selectedArrival.compareTo(arrival) == -1 &&
            selectedDeparture.compareTo(departure) == -1 &&
            selectedDeparture.compareTo(arrival) == -1) {
          isAvailable = true;
          break;
        } else if (selectedArrival.compareTo(arrival) == 1 &&
            selectedDeparture.compareTo(departure) == 1 &&
            selectedArrival.compareTo(departure) == 1) {
          isAvailable = true;
        } else {
          isAvailable = false;
          break;
        }
      }
    } else {
      isAvailable = true;
    }
    return isAvailable;
  }

  static Future<bool> canExtend(
    String? id,
    String? parkingId,
    int? departure,
  ) async {
    bool isAvailable = true;
    DateTime selectedDeparture =
        _getDateTimeFromMillisecondsFromEpoch(departure!);
    List<Parking> sessions = [];
    await FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(id)
        .collection("parking-sessions")
        .get()
        .then((value) => value.docs.forEach((element) {
              if (element.data()["upcoming"] == true) {
                sessions.add(Parking.fromJson(element.data()));
              }
            }));
    if (sessions.isNotEmpty) {
      sessions.sort((sessionA, sessionB) {
        int sessionTimeA = sessionA.getArrival! + sessionA.getDeparture!;
        int sessionTimeB = sessionB.getArrival! + sessionB.getDeparture!;

        var r = sessionTimeA.compareTo(sessionTimeB);
        if (r != 0) return r;
        return sessionTimeA.compareTo(sessionTimeB);
      });

      for (int i = 0; i < sessions.length; i++) {
        DateTime arrival =
            _getDateTimeFromMillisecondsFromEpoch(sessions[i].getArrival!);
        if (sessions[i].getParkingId!.compareTo(parkingId!) != 0) {
          if (selectedDeparture.compareTo(arrival) == 1) {
            isAvailable = false;
            break;
          }
        }
      }
    } else {
      isAvailable = true;
    }
    return isAvailable;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getParkingSessionsDocs(
      String spaceId) {
    return FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(spaceId)
        .collection('parking-sessions')
        .snapshots();
  }

  static DateTime _getDateTimeFromMillisecondsFromEpoch(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );

    return dateTime;
  }

  static void updateParkingReviews(
    String spaceId,
    Review review,
  ) async {
    final docUser = FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(spaceId)
        .collection("parking-reviews")
        .doc();

    await docUser.set(review.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getParkingSpaceReviews(
      String spaceId) {
    return FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(spaceId)
        .collection('parking-reviews')
        .snapshots();
  }

  static void updateParkingSpaceRating(
    String spaceId,
    double newRating,
    BuildContext context,
  ) async {
    int reviewsLength = 0;
    final Map<double, double> rates = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
    };
    double value = 0;
    var reviews = FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(spaceId)
        .collection('parking-reviews')
        .snapshots();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const NoticeDialog(
          imageLink: "assets/logo/lets-park-logo.png",
          message: "Saving review...",
          forLoading: true,
        ),
      ),
    );
    await reviews.forEach((documents) async {
      reviewsLength = documents.size;
      documents.docs.forEach((element) {
        value = rates[element.data()["rating"]]!;
        rates[element.data()["rating"]] = value + 1;
      });
      value = rates[newRating]!;
      rates[newRating] = value + 1;
      double newSpaceRating = ((1 * rates[1]!) +
              (2 * rates[2]!) +
              (3 * rates[3]!) +
              (4 * rates[4]!) +
              (5 * rates[5]!)) /
          (reviewsLength + 1);

      await FirebaseFirestore.instance
          .collection('parking-spaces')
          .doc(spaceId)
          .update({
        'rating': newSpaceRating,
      });
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: const NoticeDialog(
            imageLink: "assets/logo/lets-park-logo.png",
            message:
                "Thanks for reviewing!\nYour review will help others to choose a better parking.",
            forLoading: false,
          ),
        ),
      );
    });
  }

  static Row getStars(double stars) {
    List<Widget> newChildren = [];
    double length = stars;
    Color? color = Colors.amber;

    if (stars == 0) {
      length = 5;
      color = Colors.grey[400];
    }

    for (int i = 0; i < length.toInt(); i++) {
      newChildren.add(
        Icon(
          Icons.star_rounded,
          color: color,
          size: 16,
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: newChildren,
    );
  }

  static void showNavigator(LatLng position) async {
    AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull(
        'google.navigation:q=${position.latitude}, +${position.longitude}&avoid=tf',
      ),
      package: 'com.google.android.apps.maps',
    ).launch();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getEearningsToday(
      String parkingSpaceId) {
    return FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(parkingSpaceId)
        .collection('parking-sessions')
        .where("paymentDate", isEqualTo: globals.today)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getOwnedParkingSpaces() {
    return FirebaseFirestore.instance
        .collection("parking-spaces")
        .where("ownerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getActiveParkingSpaces() {
    return FirebaseFirestore.instance
        .collection("parking-spaces")
        .where("ownerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("disabled", isEqualTo: false)
        .snapshots();
  }

  static Future<int> getAvailableSlots(String spaceId) async {
    int availableSlot = 0;
    int capacity = 0;
    await FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(spaceId)
        .get()
        .then((value) {
      capacity = value.data()!["capacity"];
    });

    int occupied = 0;
    await FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(spaceId)
        .collection('parking-sessions')
        .snapshots()
        .first
        .then((value) {
      value.docs.forEach((parking) {
        if (parking.data()["inProgress"] == true ||
            parking.data()["upcoming"] == true) {
          occupied++;
        }
      });
      availableSlot = capacity - occupied;
    });

    return availableSlot;
  }

  static void updateDisableStatus(String spaceId, bool status) async {
    await FirebaseFirestore.instance
        .collection('parking-spaces')
        .doc(spaceId)
        .update({
      'disabled': status,
    });
  }

  static void deleteParkingSpace(String spaceId) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .delete();
  }

  static void updateSpaceAddress(String spaceId, String newAddress) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'address': newAddress,
    });
  }

  static void updateSpaceImageUrl(String spaceId, String newImageUrl) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'imageUrl': newImageUrl,
    });
  }

  static Future<void> updateCaretakerPhotoUrl(
      String spaceId, String newImageUrl) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'caretakerPhotoUrl': newImageUrl,
    });
  }

  static Future<void> deleteImageUrl(String url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }

  static void updateSpaceInfo(String spaceId, String newInfo) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'info': newInfo,
    });
  }

  static void updateSpaceRules(String spaceId, String newRules) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'rules': newRules,
    });
  }

  static void updateSpaceCapacity(String spaceId, int newCapacity) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'capacity': newCapacity,
    });
  }

  static Future<void> updateCaretakerName(
      String spaceId, String caretakerName) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'caretakerName': caretakerName,
    });
  }

  static Future<void> updateCaretakerPhoneNumber(
      String spaceId, String caretakerPhoneNumber) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'caretakerPhoneNumber': caretakerPhoneNumber,
    });
  }

  static void updateSpaceType(String spaceId, String newType) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'type': newType,
    });
  }

  static void updateSpaceDailyOrMonthly(
      String spaceId, String newDailyOrMonthly) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'dailyOrMonthly': newDailyOrMonthly,
    });
  }

  static void updateSpaceFeatures(
      String spaceId, List<String> newFeatures) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'features': newFeatures,
    });
  }

  static void updateSpacePaypalEmail(
      String spaceId, String newPaypalEmail) async {
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .update({
      'paypalEmail': newPaypalEmail,
    });
  }

  static Future<bool> canModify(String spaceId) async {
    bool result = true;
    await FirebaseFirestore.instance
        .collection("parking-spaces")
        .doc(spaceId)
        .collection("parking-sessions")
        .snapshots()
        .first
        .then((sessions) {
      sessions.docs.forEach((session) {
        if (session.data()['inProgress'] || session.data()['upcoming']) {
          result = false;
        }
      });
    });

    return result;
  }
}
