import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'Classes/Room.dart';
import 'authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Constants {
  static const String FirstItem = 'Create a Course Room';
  static const String SecondItem = 'Join a Course Room';
  static const String ThirdItem = 'Third Item';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
  ];
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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
            style: TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ),
        Spacer(flex: 3)
      ],
    ),
  );
}

Material displayRooms(List<room> rs) {
  return Material(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: CustomScrollView(slivers: [
            SliverList(
                delegate:
                    SliverChildListDelegate(List.generate(rs.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: roomWidget(rs[index], index),
              );
            })))
          ])));
}

Material roomWidget(room R, int i) {
  return Material(
      elevation: 22,
      borderRadius: BorderRadius.circular(24.0),
      color: Colors.blue[900],
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),

            // gradient: LinearGradient(colors: [
            //   Colors.transparent,
            //   c,
            //   c,
            //   c,
            //   c,
            //   c,
            //   c,
            //   c,
            //   c,
            //   Colors.transparent
            // ], begin: Alignment.topRight, end: Alignment.bottomRight)
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    R.className,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  "CRN:" + R.courseID,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Material(
                        elevation: 19,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: (R.grouped) ? Colors.orange[400] : Colors.grey,
                        child: Container(
                          height: 50,
                          width: 220,
                          child: Center(
                              child: Text(
                            R.groupname,
                            style: TextStyle(
                                color:
                                    (R.grouped) ? Colors.black : Colors.white70,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 19,
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.perm_identity,
                          size: 30,
                          color: Colors.white,
                        ),
                        Text(
                          R.availStudents.toString() +
                              "/" +
                              R.totalStudents.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "available",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Spacer(
                      flex: 20,
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.group_work,
                          size: 30,
                          color: Colors.white,
                        ),
                        Text(
                          R.availGroups.toString() + " groups",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "available",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ));
}

class _myHomePageState extends State<HomePage> {
  _myHomePageState();
  final List<String> roomIds = [];
  final List<room> rooms = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference Dbref = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child("rooms");

    Dbref.onValue.listen((event) {
      roomIds.clear();
      rooms.clear();
      var dataSnapShot = event.snapshot;
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;
      for (var key in keys) {
        roomIds.add(key);
        print(values[key]);
        var gname = "Not Grouped";
        DatabaseReference re = FirebaseDatabase.instance
            .reference()
            .child("groups")
            .child(values[key]);
        re.onValue.listen((event) {
          var dataSnapSho = event.snapshot;
          var ke = dataSnapSho.value.keys;
          var valu = dataSnapSho.value;
          print(valu['gName']);
          gname = valu['gName'];
        });
        DatabaseReference ref =
            FirebaseDatabase.instance.reference().child("rooms").child(key);
        ref.onValue.listen((event) {
          var dataSnapShots = event.snapshot;
          var keyse = dataSnapShots.value.keys;
          var valuese = dataSnapShots.value;
          var t = (values[key] == "n/a") ? false : true;
          room rl = new room(
              valuese['cName'],
              valuese['cID'],
              valuese['avail_groups'],
              valuese['avail_Students'],
              valuese['tot_Students'],
              t,
              gname);
          print(gname);
          rooms.add(rl);
        });
      }
    });
    setState(() {});
  }

  final databaseReference = FirebaseDatabase.instance;
  @override
  Widget build(BuildContextcontext) {
    void choiceAction(String choice) {
      if (choice == Constants.FirstItem) {
        print('I First Item');
      } else if (choice == Constants.SecondItem) {
        print('I Second Item');
        _AddCR(context);
      } else if (choice == Constants.ThirdItem) {
        print('I Third Item');
      }
    }

    print(rooms);
    print(roomIds);
    return Scaffold(
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
          PopupMenuButton<String>(
            onSelected: choiceAction,
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: (roomIds.isEmpty) ? nothing() : displayRooms(rooms),
    );
  }
}

void _AddCR(context) {
  print("ey");
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            alignment: Alignment.topLeft,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Enter Location ID:",
                          style: TextStyle(fontSize: 24),
                        ),
                        Spacer(
                          flex: 19,
                        ),
                        IconButton(icon: Icon(Icons.qr_code), onPressed: null),
                        Spacer()
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      obscureText: true,
                    ),
                  ],
                )));
      });
}

void _CreateCR(context) {
  print("ey");
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            alignment: Alignment.topLeft,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Enter Location ID:",
                          style: TextStyle(fontSize: 24),
                        ),
                        Spacer(
                          flex: 19,
                        ),
                        IconButton(icon: Icon(Icons.qr_code), onPressed: null),
                        Spacer()
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      obscureText: true,
                    ),
                  ],
                )));
      });
}
