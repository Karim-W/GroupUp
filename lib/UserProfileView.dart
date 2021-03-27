import 'package:GroupUp/Classes/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_service.dart';

class upv extends StatefulWidget {
  upv(this.uid);
  final uid;
  @override
  State<StatefulWidget> createState() {
    return _upv(uSer: uid);
  }
}

class _upv extends State<upv> {
  _upv({this.uSer});
  final uSer;
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final eMailController = TextEditingController();
  final phoneController = TextEditingController();
  user theUser = new user("n", "a", "", "", null, null);
  bool isEnabled = false;
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
              onPressed: () {},
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
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Phone num:",
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
                      controller: phoneController,
                      enabled: isEnabled,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: theUser.phone),
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
                    "Email :",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    width: 330,
                    height: 45,
                    child: TextField(
                      controller: eMailController,
                      enabled: isEnabled,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: theUser.email),
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
