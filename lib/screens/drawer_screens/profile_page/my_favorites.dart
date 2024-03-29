// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_park/globals/globals.dart' as globals;
import 'package:lets_park/models/parking_space.dart';
import 'package:lets_park/screens/popups/parking_area_information.dart';
import 'package:lets_park/services/parking_space_services.dart';
import 'package:lets_park/services/user_services.dart';
import 'package:lets_park/shared/shared_widgets.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({Key? key}) : super(key: key);

  @override
  State<MyFavorites> createState() => MyFavoritesState();
}

class MyFavoritesState extends State<MyFavorites> {
  final _sharedWidgets = SharedWidget();
  List<ParkingSpace> _favorites = [];

  @override
  void initState() {
    _favorites = getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _sharedWidgets.manageSpaceAppBar("My Favorites"),
      backgroundColor: Colors.grey.shade100,
      body: _favorites.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.network(
                            _favorites[index].getImageUrl!,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red[400],
                                    size: 17,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      _favorites[index].getAddress!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  ParkingSpaceServices.getStars(
                                    _favorites[index].getRating!,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(3)),
                                        ),
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          _favorites[index].getType!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.orange[400],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(3)),
                                        ),
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          _favorites[index].getDailyOrMonthly!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          UserServices.removeSpaceonFavorites(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            _favorites[index].getSpaceId!,
                                          );
                                          showNotice(
                                            context,
                                            "Parking space remove from My Favorites",
                                          );
                                          setState(() {
                                            _favorites = getFavorites();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.favorite_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () async {
                                          bool verified =
                                              await ParkingSpaceServices
                                                  .isVerified(
                                            _favorites[index].getSpaceId!,
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ParkingAreaInformation(
                                                parkingSpace: _favorites[index],
                                                verified: verified &&
                                                    _favorites[index]
                                                            .getRating! >=
                                                        4,
                                              ),
                                            ),
                                          ).then((value) {
                                            setState(() {
                                              _favorites = getFavorites();
                                            });
                                          });
                                        },
                                        child: const Icon(
                                          Icons.open_in_new_rounded,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "No favorite parking spaces.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<ParkingSpace> getFavorites() {
    List<ParkingSpace> favorites = [];

    globals.currentParkingSpaces.forEach((space) {
      if (globals.favorites.contains(space.getSpaceId)) {
        favorites.add(space);
      }
    });
    return favorites;
  }

  void showNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
