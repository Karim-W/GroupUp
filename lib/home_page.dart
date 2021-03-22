import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';

import 'authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Location {
  String id, name, city, area, locImg, lastUpdated;
  int activeViolation;
  double long, lat;
  Location(this.id, this.activeViolation, this.area, this.city, this.lat,
      this.long, this.name, this.locImg, this.lastUpdated);
}

class HomePage extends StatefulWidget {
  HomePage({this.app});
  final FirebaseApp app;
  @override
  State<StatefulWidget> createState() {
    return _myHomePageState();
  }
}

Material nothing() {
  return Material(
    child: Column(
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            "You have not joined any course room.\n\n\n click the + button to join or create one",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
        ),
        Spacer(flex: 3)
      ],
    ),
  );
}

Material displayRooms() {
  return Material(
      child: Center(
    child: Text(
        "You have not joined any course rooms click the + button to join or create one"),
  ));
}

class _myHomePageState extends State<HomePage> {
  List<String> LocationIds = [];
  List<Location> userLocations = [];
  List<int> vioArr = [3, 5, 2, 1, 0];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {});
  }

  final databaseReference = FirebaseDatabase.instance;
  @override
  Widget build(BuildContextcontext) {
    return new Scaffold(
      //backgroundColor: Color(0xff0B0500),
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () {},
        ),
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          FlatButton(
            //textColor: Colors.white,
            textColor: Colors.black,
            onPressed: () {
              //context.read<AuthenticationService>().signOut();
              var a = userLocations
                  .sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
              print(userLocations);
              setState(() => this
                  .userLocations
                  .sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated)));
            },
            child: IconButton(
              icon: Icon(Icons.add),
              iconSize: 30,
              color: Colors.black,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: (LocationIds.isEmpty) ? nothing() : null,
    );
  }
}
