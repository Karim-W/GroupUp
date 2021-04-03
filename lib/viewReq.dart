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

void updategroups(request r) {
  DatabaseReference Dbref =
      FirebaseDatabase.instance.reference().child("groups").child(r.gID);
  Dbref.once().then((DataSnapshot snapshot) {
    var keys = snapshot.value.keys;
    var values = snapshot.value;
    var c = values['count'];
    DatabaseReference Dbre =
        FirebaseDatabase.instance.reference().child("rooms").child(r.cID);
    Dbre.once().then((DataSnapshot dataSnapSho1) {
      var dbreK = dataSnapSho1.value.keys;
      var dbreV = dataSnapSho1.value;
      var spg = dbreV['SPG'];
      if (c + 1 <= spg) {
        Dbref.update({'count': (c + 1)});

        print(spg);
        DatabaseReference Db = FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(FirebaseAuth.instance.currentUser.uid);
        Db.once().then((DataSnapshot dataSnapSho) {
          var fn = dataSnapSho.value['fname'];
          var ln = dataSnapSho.value['lname'];
          Dbref.child("members").update({
            FirebaseAuth.instance.currentUser.uid.toString(): fn + " " + ln
          });
          Db.child("groups").set({r.gID: false});
          Db.child("rooms").update({r.cID: r.gID});
        });
      }
    });
  });
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
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Wrap(children: [
                    Text(
                      rEQ.msg,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20),
                    ),
                  ]),
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
                      onPressed: () {
                        updategroups(rEQ);
                      }),
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
                      onPressed: () {
                        //if g
                      }),
                  Text(
                    "Decline",
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
