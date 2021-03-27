// TODO Implement this library.
import 'package:GroupUp/Classes/Group.dart';
import 'package:GroupUp/Classes/Room.dart';
import 'package:GroupUp/UserProfileView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class cRV extends StatefulWidget {
  cRV({this.room});
  //final FirebaseApp app;
  final room;
  @override
  State<StatefulWidget> createState() {
    return _cRV(CR: room);
  }
}

Center buildView(String id) {
  switch (id) {
    case "Student":
      return Center(
        child: Text("hi"),
      );
    case "Groups":
      return Center(
        child: Text("hello"),
      );
    case "My Groups":
      return Center(
        child: Text(
          "eyy",
          style: TextStyle(color: Colors.black),
        ),
      );
  }
}

Material displayGroup(group g, room R) {
  if (R.grouped) {
    return Material(
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Spacer(),
            Wrap(
              spacing: 16.0, // gap between adjacent chips
              runSpacing: 8.0, // gap between lines
              children: <Widget>[
                for (var i in g.members)
                  InkWell(
                    onLongPress: () {},
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade900,
                      child: Text(
                        i,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            Spacer(
              flex: 19,
            ),
          ],
        ),
      ),
    );
  } else {
    return Material(
      child: Text(g.gName),
    );
  }
}

class _cRV extends State<cRV> {
  _cRV({this.CR});
  room CR;
  group myGroup = new group("", "", null, 0);
  List<String> students = [];
  List<String> sIDs = [];
  List<String> groups = [];
  List<String> gIDs = [];
  @override
  void initState() {
    super.initState();
    students.cast();
    sIDs.cast();
    groups.cast();
    gIDs.cast();
    myGroup = new group("", "", null, 0);
    final databaseReference = FirebaseDatabase.instance;
    DatabaseReference Dbref = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child("rooms")
        .child(CR.roomID);
    Dbref.onValue.listen((event) {
      var dataSnapShot = event.snapshot;
      var values = dataSnapShot.value;
      print(values.toString());
      DatabaseReference re = FirebaseDatabase.instance
          .reference()
          .child("groups")
          .child(values.toString());
      re.onValue.listen((event) {
        var dataSnapSho = event.snapshot;
        var ke = dataSnapSho.value.keys;
        var valu = dataSnapSho.value;
        var t = valu['members'];
        var l = valu['members'].values.toList();
        List<String> mem = [];
        for (var o in l) {
          mem.add(o.toString());
        }
        myGroup =
            new group(valu['gName'], values.toString(), mem, valu['count']);
      });
    });
    DatabaseReference Db = FirebaseDatabase.instance
        .reference()
        .child("rooms")
        .child(CR.roomID)
        .child("students");
    Db.onValue.listen((event) {
      var dataSnapSho = event.snapshot;
      var ke = dataSnapSho.value.keys;
      var valu = dataSnapSho.value;
      var id = valu.keys.toList();
      var nm = valu.values.toList();
      for (var i = 0; i < id.length; i++) {
        students.add(nm[i]);
        sIDs.add(id[i]);
      }
    });
    DatabaseReference Dtt = FirebaseDatabase.instance
        .reference()
        .child("rooms")
        .child(CR.roomID)
        .child("groups");
    Dtt.onValue.listen((event) {
      var dataSnapSho = event.snapshot;
      var ke = dataSnapSho.value.keys;
      var valu = dataSnapSho.value;
      var id = valu.keys.toList();
      var nm = valu.values.toList();
      for (var i = 0; i < id.length; i++) {
        groups.add(nm[i]);
        gIDs.add(id[i]);
      }
    });

    setState(() {});
  }

  //students
  String _storeID;
  final databaseReference = FirebaseDatabase.instance;
  @override
  Widget build(BuildContextcontext) {
    Future.delayed(const Duration(milliseconds: 5), () {
// Here you can write your code

      setState(() {
        // Here you can write your code for open new view
      });
    });
    final List<Tab> myTabs = <Tab>[
      Tab(text: 'Students'),
      Tab(text: 'Groups'),
      Tab(text: 'My Group'),
    ];
    return DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
              bottom: TabBar(
                tabs: myTabs,
                labelColor: Colors.blue[900],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                CR.className,
                style: TextStyle(color: Colors.black),
              ),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )),
          body: TabBarView(
            children: myTabs.map((Tab tab) {
              final String label = tab.text.toLowerCase();
              return Container(
                child: (label == "my group")
                    ? displayGroup(myGroup, CR)
                    : Container(
                        child: ListView.builder(
                          itemCount: (label == "students")
                              ? students.length
                              : groups.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  (label == "students")
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  upv(sIDs.elementAt(index))))
                                      : groups.elementAt(index);
                                },
                                title: Text((label == "students")
                                    ? students.elementAt(index)
                                    : groups.elementAt(index)));
                          },
                        ),
                      ),
              );
              // ListView.builder(
              //     itemCount: violations.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return ListTile(
              //           trailing: Icon(Icons.arrow_forward),
              //           onTap: () {
              //             print(violations.elementAt(index).time);
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => violationView(
              //                         violationInst:
              //                             violations.elementAt(index),
              //                         longCord: LongCord,
              //                         latCord: LatCord)));
              //           },
              //           title: Text(violations.elementAt(index).date +
              //               " " +
              //               violations.elementAt(index).time));
              //     }),
              // );
            }).toList(),
          ),

          // body: ListView.builder(
          //     itemCount: violations.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return ListTile(
          //           trailing: Icon(Icons.arrow_forward),
          //           onTap: () {
          //             print(violations.elementAt(index).time);
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => violationView(
          //                         violationInst: violations.elementAt(index),
          //                         longCord: LongCord,
          //                         latCord: LatCord)));
          //           },
          //           title: Text(violations.elementAt(index).date +
          //               " " +
          //               violations.elementAt(index).time));
          //     }),
        ));
  }
}
