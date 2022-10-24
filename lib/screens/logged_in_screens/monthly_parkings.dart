import 'package:flutter/material.dart';
import 'package:lets_park/services/firebase_api.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_park/models/parking_space.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lets_park/screens/popups/parking_area_info.dart';

class MonthlyParkingsPage extends StatefulWidget {
  const MonthlyParkingsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MonthlyParkingsPage> createState() => _MonthlyParkingsPageState();
}

class _MonthlyParkingsPageState extends State<MonthlyParkingsPage> {
  List<ParkingSpace> spaces = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 17,),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Monthly Parkings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        bottom: PreferredSize(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              textAlign: TextAlign.start,
              maxLines: 1,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                onPressed: () {
                  
                },
                icon: const Icon(
                    Icons.search,
                    color: Colors.black54,
                    size: 20,
                  ),
                ),
                isDense: true,
                hintText: 'Enter location here',
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3, 
                    color: Colors.grey.shade200,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(70),
        ),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseServices.getMonthlyParkingSpaces(), 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            spaces.clear();
            snapshot.data!.docs.forEach((space) {
              spaces.add(ParkingSpace.fromJson(space.data()));
            });
            return SingleChildScrollView(
                child: Padding(
                padding: EdgeInsets.all(16),
                child: MonthlyParkingSpaceGrid(spaces: spaces),
              ),
            );
          } else {
            return const Center( child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class MonthlyParkingSpaceGrid extends StatefulWidget {
  final List<ParkingSpace> spaces;
  const MonthlyParkingSpaceGrid({Key? key, required this.spaces}) : super(key: key);

  @override
  State<MonthlyParkingSpaceGrid> createState() => MonthlyParkingSpaceGridState();
}

class MonthlyParkingSpaceGridState extends State<MonthlyParkingSpaceGrid> {
  List<ParkingSpace> spaces = [];
  bool loading = false;

  @override
  void initState() {
    spaces = widget.spaces;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      children: spaces
          .map((space) => MonthlyParkingSpaceCard(
                space: space,
              ))
          .toList(),
    );
  }
}

class MonthlyParkingSpaceCard extends StatelessWidget {
  final ParkingSpace space;
  const MonthlyParkingSpaceCard({
    Key? key,
    required this.space,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Colors.black54,
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcOver,
              ),
              image: NetworkImage(
                space.getImageUrl!,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_rounded ,
                      color: Colors.blue.shade100,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                      "${space.getAddress!}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    ),
                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "${space.getRating!.toInt()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => ParkingAreaInfo(
                          parkingSpace: space,
                        ),
                      ),
                    );
                  },
                  child: const Text("View space"),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      20,
                    ),
                    side: const BorderSide(color: Colors.grey),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}