import 'dart:ui';

import 'package:e_shop/Authentication/login.dart';
import 'package:e_shop/Authentication/register.dart';
import 'package:flutter/material.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pink, Colors.lightGreenAccent],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          title: Text(
            'e-Shop',
            style: TextStyle(
              fontSize: 55,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: 'Login',
              ),
              Tab(
                icon: Icon(
                  Icons.perm_contact_calendar,
                  color: Colors.white,
                ),
                text: 'Register',
              )
            ],
            indicatorColor: Colors.white30,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
          child: TabBarView(children: [
            Login(),
            Register(),
          ]),
        ),
      ),
    );
  }
}
