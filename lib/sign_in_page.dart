import 'home_page.dart';

import 'authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:playground/Models/CustomShowDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("users");
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rpasswordController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   iconTheme: IconThemeData(color: Colors.white),
        //   elevation: 0.0,
        //   title: Text(
        //     '',
        //     style: TextStyle(
        //         fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        //   ),
        // ),
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        //padding: const EdgeInsets.all(25.0),
        key: _formKey,
        child: Column(
          children: [
            Spacer(),
            Container(
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/images/AppLogo.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Enter Your E-mail",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Enter Your Password",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                obscureText: true,
              ),
            ),
            Spacer(
              flex: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: FlatButton(
                onPressed: () {
                  context.read<AuthenticationService>().signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text(
                  "Sign-In",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: FlatButton(
                onPressed: () {
                  _Registeruser(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: FlatButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
            Spacer(
              flex: 20,
            ),
            Text(
              "Copyright© 2021 SDD. All rights reserved.",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    ));
  }

  void _Registeruser(context) {
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
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          size: 30,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: fnameController,
                      decoration: InputDecoration(
                        labelText: "Enter Your First Name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: lnameController,
                      decoration: InputDecoration(
                        labelText: "Enter Your Last Name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter Your E-Mail",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "Enter Your Phone Number",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: rpasswordController,
                      decoration: InputDecoration(
                        labelText: "Enter Password",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: confirmController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: RaisedButton(
                      onPressed: () {
                        if (rpasswordController.text ==
                            confirmController.text) {
                          registerToFb(context);
                        } else {
                          //_incorrectPass(context, "Password Mismatch",
                          //    "Both passwords entered do not match. Please make sure they are the same.");
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.black,
                      child: Text(
                        "Sign-Up",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
          );
        });
  }

  void registerToFb(context) {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: rpasswordController.text)
        .then((result) {
      print(fnameController.text);
      print(fnameController.text);
      print(fnameController.text);
      print(fnameController.text);
      dbRef.child(result.user.uid).set({
        "email": emailController.text.trim(),
        "fname": fnameController.text.trim(),
        "lame": lnameController.text.trim(),
        "phone": phoneController.text.trim(),
      }).then((res) {
        //isLoading = false;
        Navigator.of(context).pop();
      });
    });
  }

//   void _incorrectPass(context, title, msg) {
//     String titleheading = title;
//     String msgInfo = msg;

//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return new CustomAlertDialog(
//             content: new Container(
//                 width: 300,
//                 height: 200,
//                 decoration: new BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   color: const Color(0xFFFFFF),
//                   borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: <Widget>[
//                       Text(
//                         titleheading,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 24),
//                       ),
//                       Spacer(),
//                       Text(
//                         msgInfo,
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal, fontSize: 16),
//                       ),
//                       Spacer(),
//                       Padding(
//                           padding: EdgeInsets.only(top: 16),
//                           child: RaisedButton(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18.0),
//                             ),
//                             child: Text("Okay"),
//                             color: Colors.black,
//                             textColor: Colors.white,
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           )),
//                       Spacer(),
//                     ],
//                   ),
//                 )),
//           );
//         });
//   }

//   void SignUP() {
//     print('something exciting is going to happen here...');
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// //import 'home.dart';

// class SignInPage extends StatefulWidget {
//   @override
//   _SignInPage createState() => _SignInPage();
// }

// class _SignInPage extends State<SignInPage> {
//   bool isLoading = false;
//   final _formKey = GlobalKey<FormState>();
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   DatabaseReference dbRef =
//       FirebaseDatabase.instance.reference().child("Users");
//   TextEditingController emailController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController ageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("Sign Up")),
//         body: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//                 child: Column(children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: TextFormField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     labelText: "Enter User Name",
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Enter User Name';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: "Enter Email",
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Enter an Email Address';
//                     } else if (!value.contains('@')) {
//                       return 'Please enter a valid email address';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: TextFormField(
//                   controller: ageController,
//                   decoration: InputDecoration(
//                     labelText: "Enter Age",
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Enter Age';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: TextFormField(
//                   obscureText: true,
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     labelText: "Enter Password",
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value.isEmpty) {
//                       return 'Enter Password';
//                     } else if (value.length < 6) {
//                       return 'Password must be atleast 6 characters!';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: isLoading
//                     ? CircularProgressIndicator()
//                     : RaisedButton(
//                         color: Colors.lightBlue,
//                         onPressed: () {
//                           if (_formKey.currentState.validate()) {
//                             setState(() {
//                               isLoading = true;
//                             });
//                             registerToFb();
//                           }
//                         },
//                         child: Text('Submit'),
//                       ),
//               )
//             ]))));
//   }

//   void registerToFb() {
//     firebaseAuth
//         .createUserWithEmailAndPassword(
//             email: emailController.text, password: passwordController.text)
//         .then((result) {
//       dbRef.child(result.user.uid).set({
//         "email": emailController.text,
//         "age": ageController.text,
//         "name": nameController.text
//       }).then((res) {
//         isLoading = false;
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
//         //);
//       });
//     }).catchError((err) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Error"),
//               content: Text(err.message),
//               actions: [
//                 FlatButton(
//                   child: Text("Ok"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             );
//           });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     ageController.dispose();
//   }
// }
}
