import 'dart:math';

import 'package:GroupUp/Classes/Group.dart';
import 'package:GroupUp/Classes/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Classes/Room.dart';
import 'authentication_service.dart';

class upv extends StatefulWidget {
  upv(this.uid, this.course, this.mygroup);
  final uid;
  final course;
  final mygroup;
  @override
  State<StatefulWidget> createState() {
    return _upv(uSer: uid, cR: course, myG: mygroup);
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _upv extends State<upv> {
  _upv({this.uSer, this.cR, this.myG});
  final uSer;
  room cR;
  group myG;
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final eMailController = TextEditingController();
  final phoneController = TextEditingController();
  user theUser = new user("n", "a", "", "", null, null);
  bool isEnabled = false;
  String fn;
  String ln;

  // void updateInformation(course) {
  //   setState(() => _information = information);
  // }

  // void moveToSecondPage() async {
  //   final information = await Navigator.push(
  //     context,
  //     CupertinoPageRoute(
  //         fullscreenDialog: true, builder: (context) => SecondPage()),
  //   );
  //   updateInformation(information);
  // }

  @override
  void initState() {
    super.initState();
    DatabaseReference Dbref =
        FirebaseDatabase.instance.reference().child("users").child(uSer);

    Dbref.onValue.listen((event) {
      var dataSnapShot = event.snapshot;
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;
      //print(values);
      var TS = values['tSkills'].toList();
      var SS = values['sSkills'].toList();
      List<String> ts = [];
      List<String> ss = [];
      for (var i = 0; i < TS.length; i++) {
        if (TS[i].toString() == "null") {
        } else {
          ts.add(TS[i]);
        }
      }
      for (var i = 0; i < SS.length; i++) {
        if (SS[i].toString() == "null") {
        } else {
          ss.add(SS[i]);
        }
      }
      theUser = new user(values['fname'], values['lname'], values['phone'],
          values['email'], ss, ts);
      print(theUser.email);
      fNameController.text = theUser.fname;
      lNameController.text = theUser.lname;
      eMailController.text = theUser.email;
      phoneController.text = theUser.phone;
      DatabaseReference Dref = FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(FirebaseAuth.instance.currentUser.uid);
      Dref.onValue.listen((event) {
        var dataSnapShot = event.snapshot;
        var ks = dataSnapShot.value.keys;
        var vss = dataSnapShot.value;
        fn = vss['fname'];
        ln = vss['lname'];
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContextcontext) {
    DatabaseReference Dbref = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser.uid);
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: Text(
            "Profile Settings",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                var reqID = getRandomString(28);
                print(reqID);
                var f = theUser.fname;
                var l = theUser.lname;
                showDialog(
                    context: context,
                    child: new AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      title: new Text(
                        "Add $f $l?",
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 200,
                        child: new Column(
                          children: [
                            Text("data"),
                            RaisedButton(
                              onPressed: () {
                                var rId = getRandomString(30);
                                DatabaseReference Dbre = FirebaseDatabase
                                    .instance
                                    .reference()
                                    .child("reqs");
                                Dbre.child(rId).set({
                                  "gID": myG.gID,
                                  "gName": myG.gName,
                                  "from": fn + " " + ln,
                                  "fromID": FirebaseAuth
                                      .instance.currentUser.uid
                                      .toString(),
                                  "toID": uSer.toString(),
                                  "msg": "hi",
                                  "cID": cR.roomID,
                                  "cName": cR.className,
                                });
                                DatabaseReference Dbee = FirebaseDatabase
                                    .instance
                                    .reference()
                                    .child("users")
                                    .child(uSer);
                                Dbee.child("reqs").child(rId).set({
                                  "from": fn + " " + ln,
                                  "Course": cR.className
                                }).then((res) {
                                  //isLoading = false;
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text("submit"),
                            )
                          ],
                        ),
                      ),
                    ));
              },
              color: Colors.black,
              iconSize: 30,
            )
          ],
        ),
        body: Column(
          children: [
            Spacer(),
            Center(
              child: InkWell(
                onTap: () {},
                child: CircleAvatar(
                  backgroundColor: Colors.blue[900],
                  radius: 70,
                  child: Text(
                    theUser.fname[0] + theUser.lname[0],
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "First Name :",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: 290,
                    height: 45,
                    child: TextField(
                      controller: fNameController,
                      enabled: isEnabled,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: theUser.fname),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last Name :",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: 290,
                    height: 45,
                    child: TextField(
                      controller: lNameController,
                      enabled: isEnabled,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: theUser.lname),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Soft Skills :",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Wrap(
              spacing: 16,
              children: [
                for (var i in theUser.sSkills)
                  CircleAvatar(
                    child: Text(
                      i.toString(),
                      textAlign: TextAlign.center,
                    ),
                    radius: 50,
                  ),
              ],
            ),
            Spacer(flex: 2),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Technical Skills :",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Wrap(
              spacing: 16,
              children: [
                for (var i in theUser.tSkills)
                  CircleAvatar(
                    child: Text(
                      i.toString(),
                      textAlign: TextAlign.center,
                    ),
                    radius: 50,
                  ),
              ],
            ),
            Spacer(
              flex: 19,
            ),
          ],
        ));
  }
}
