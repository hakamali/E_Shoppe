import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FirebaseCredentials{
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  Firestore user;
}