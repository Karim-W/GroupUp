import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class req extends StatefulWidget {
  req();
  //final FirebaseApp app;

  @override
  State<StatefulWidget> createState() {
    return _req();
  }
}

class _req extends State<req> {
  _req();

  void initState() {
    super.initState();
    courses.clear();
    rID.clear();
    from.clear();
    setState(() {});
    DatabaseReference Dbref = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child("req");
    Dbref.onValue.listen((event) {
      var dataSnapShot = event.snapshot;
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;
      var r = keys.toList();
      for (var i in r) {
        rID.add(i.toString());
        DatabaseReference Dbre = FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(FirebaseAuth.instance.currentUser.uid)
            .child("req")
            .child(i.toString());
        print("ayyyy" + i.toString());
        print(values[i]['from']);
        courses.add(values[i]['Course']);
        from.add(values[i]['from']);
      }
      setState(() {});
    });
  }

  String _storeID;
  final databaseReference = FirebaseDatabase.instance;
  List<String> from = [];
  List<String> courses = [];
  List<String> rID = [];
  @override
  Widget build(BuildContextcontext) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Requests",
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
      body: ListView.builder(
          itemCount: rID.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => violationView(
                  //             violationInst: violations.elementAt(index),
                  //             longCord: LongCord,
                  //             latCord: LatCord)));
                },
                title: Text("From " + from.elementAt(index)));
          }),
    );
  }
}
