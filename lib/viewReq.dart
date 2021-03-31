import 'package:GroupUp/Classes/req.dart';
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
  request rEQ;
  void initState() {
    super.initState();
    DatabaseReference Dbref =
        FirebaseDatabase.instance.reference().child("reqs").child(rid);
    Dbref.onValue.listen((event) {
      var dataSnapShot = event.snapshot;
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;
      rEQ = new request(
          rid,
          values['gID'],
          values['cID'],
          values['fromID'],
          values['toID'],
          values['msg'],
          values['from'],
          values['cName'],
          values['gName']);
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
            child: Row(children: [
              Text(
                "From: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                rEQ.sender,
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.perm_identity),
                onPressed: () {},
                splashRadius: 1,
              )
            ]),
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8, bottom: 8),
            child: Row(children: [
              Text(
                "Group: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                rEQ.groupN,
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.group),
                onPressed: () {},
                splashRadius: 1,
              )
            ]),
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8, bottom: 8),
            child: Row(children: [
              Text(
                "Course: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                rEQ.courseName,
                style: TextStyle(fontSize: 20),
              )
            ]),
          ),
          Divider(
            height: 5,
            color: Colors.black,
          ),
          // Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  rEQ.msg,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Spacer(
            flex: 10,
          ),
          Row(
            children: [
              Spacer(),
              Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.check_circle_outline),
                      iconSize: 70,
                      color: Colors.green,
                      onPressed: () {}),
                  Text(
                    "Accept",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.highlight_off_rounded),
                      iconSize: 70,
                      color: Colors.red,
                      onPressed: () {}),
                  Text(
                    "Accept",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Spacer()
            ],
          ),
          Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }
}
