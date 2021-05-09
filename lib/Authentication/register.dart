import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Store/store_home.dart';
import 'package:e_shop/Widgets/CustomTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameditingController = TextEditingController();

  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _passwordditingController =
      TextEditingController();
  final TextEditingController _cPasswordditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenhieght = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenwidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenwidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameditingController,
                      data: Icons.person,
                      hintText: 'Name',
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _emailditingController,
                      data: Icons.email,
                      hintText: 'Email',
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordditingController,
                      data: Icons.person,
                      hintText: 'Password',
                      isObsecure: true,
                    ),
                    CustomTextField(
                      controller: _cPasswordditingController,
                      data: Icons.person,
                      hintText: 'Confirm Password',
                      isObsecure: true,
                    )
                  ],
                )),
            RaisedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              color: Colors.pink,
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 4,
              width: _screenwidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: 'Please selected an image file.');
          });
    } else {
      _passwordditingController.text == _cPasswordditingController.text
          ? _emailditingController.text.isNotEmpty &&
                  _passwordditingController.text.isNotEmpty &&
                  _cPasswordditingController.text.isNotEmpty &&
                  _nameditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog(
                  'Please fill up the registration complete form...')
          : displayDialog('Password don not match');
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Registering please wait...',
          );
        });
    String imageFilename = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFilename);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailditingController.text.trim(),
      password: _passwordditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StoreHome()));
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance.collection('users').document(fUser.uid).setData({
      'uid': fUser.uid,
      'email': fUser.email,
      'name': _nameditingController.text.trim(),
      'url': userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences.setString('uid', fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
