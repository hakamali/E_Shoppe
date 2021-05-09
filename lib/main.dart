import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/ItemQuantity.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Store/store_home.dart';
import 'package:e_shop/utils/add_device.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth=FirebaseAuth.instance;
  EcommerceApp.sharedPreferences=await SharedPreferences.getInstance();
  EcommerceApp.firestore=Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[

ChangeNotifierProvider(
  create: (c)=>CartItemCounter() ),
  ChangeNotifierProvider(
  create: (c)=>ItemQuantity() ),
  ChangeNotifierProvider(
  create: (c)=>AddressChanger() ) ,
  ChangeNotifierProvider(
  create: (c)=>TotalAmount() )



      ],
      child: MaterialApp(
        title: 'e-Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: SplashScreen()),
      );
  }
}


