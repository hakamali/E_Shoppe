
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/store_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_shop/utils/firebaseCredentials.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/authentic_screen.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 4), onLoading);
  }

  onLoading() async {
    // if ( await EcommerceAppp.auth.currentUser()!=null)
    if ( await FirebaseAuth.instance.currentUser()!=null)

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StoreHome()));
    else
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AuthenticScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink, Colors.lightGreen],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/welcome.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'World Largest Online Shop',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ));
  }
}