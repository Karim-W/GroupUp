import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'Classes/Room.dart';
import 'authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Constants {
  static const String FirstItem = 'Create a Course Room';
  static const String SecondItem = 'Join a Course Room';
  static const String ThirdItem = 'Third Item';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
  ];
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
            style: TextStyle(fontSize: 22, color: Colors.grey),
          ),
        ),
        Spacer(flex: 3)
      ],
    ),
  );
}

final List<Color> colors = [
  Colors.red[500],
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple
];
final List<room> roomIds = [];
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
                child: roomWidget(roomIds[index], index),
              );
            })))
          ])));
}

Material roomWidget(room R, int i) {
  Color c = colors[i % colors.length];
  return Material(
      elevation: 22,
      borderRadius: BorderRadius.circular(24.0),
      color: colors[i % colors.length],
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
          )));
}

class _myHomePageState extends State<HomePage> {
  List<String> LocationIds = [];
  //List<Room> Rooms = [];
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

    room r = new room("Software NGN", "", "", 0, 0);
    roomIds.add(r);
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
      body: (roomIds.isEmpty) ? nothing() : displayRooms(roomIds),
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
