import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class reqView extends StatefulWidget {
  reqView(this.reqID);
  //final FirebaseApp app;
  final reqID;

  @override
  State<StatefulWidget> createState() {
    return _reqView(rid: reqID);
  }
}

class _reqView extends State<reqView> {
  _reqView({this.rid});
  final rid;
  void initState() {
    DatabaseReference Dbref =
        FirebaseDatabase.instance.reference().child("reqs").child(rid);
    // super.initState();
    // courses.clear();
    // rID.clear();
    // from.clear();
    // setState(() {});
    // DatabaseReference Dbref = FirebaseDatabase.instance
    //     .reference()
    //     .child("users")
    //     .child(FirebaseAuth.instance.currentUser.uid)
    //     .child("req");
    // Dbref.onValue.listen((event) {
    //   var dataSnapShot = event.snapshot;
    //   var keys = dataSnapShot.value.keys;
    //   var values = dataSnapShot.value;
    //   var r = keys.toList();
    //   for (var i in r) {
    //     rID.add(i.toString());
    //     DatabaseReference Dbre = FirebaseDatabase.instance
    //         .reference()
    //         .child("users")
    //         .child(FirebaseAuth.instance.currentUser.uid)
    //         .child("req")
    //         .child(i.toString());
    //     print("ayyyy" + i.toString());
    //     print(values[i]['from']);
    //     courses.add(values[i]['Course']);
    //     from.add(values[i]['from']);
    //   }
    //   setState(() {});
    // });
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
            "View Request",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8, bottom: 8),
            child: Row(children: [Text("From: ")]),
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8, bottom: 8),
            child: Row(children: [Text("Group: ")]),
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8, bottom: 8),
            child: Row(children: [Text("Course: ")]),
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
