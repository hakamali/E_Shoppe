import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/authentic_screen.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDTextEditingController =
      TextEditingController();
  final TextEditingController _passwordditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenhieght = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink, Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)
          ),
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'images/admin.png',
              height: 240,
              width: 240,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Admin',
              style: TextStyle(color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: 'iD',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordditingController,
                    data: Icons.person,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () {
              _adminIDTextEditingController.text.isNotEmpty &&
                      _passwordditingController.text.isNotEmpty
                  ? loginAdmin()
                  : showDialog(
                      context: context,
                      builder: (c) {
                        return ErrorAlertDialog(
                          message: 'Please write email and password ',
                        );
                      });
            },
            color: Colors.pink,
            child: Text(
              'login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 4,
            width: _screenwidth * 0.8,
            color: Colors.pink,
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthenticScreen()));
              },
              icon: Icon(
                Icons.nature_people,
                color: Colors.pink,
              ),
              label: Text(
                'I am not  Admin',
                style:
                    TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 50.0,
          ),
        ],
      )),
    );
  }

  loginAdmin() {

    Firestore.instance.collection('admins').getDocuments()
        .then((snapShot){
          snapShot.documents.forEach((result){
            if(result.data['id'] !=_adminIDTextEditingController.text.trim())
              {

                Scaffold.of(context).showSnackBar(SnackBar(content: Text('your id is not correct')));


              }

          else  if(result.data['password'] !=_passwordditingController.text.trim())
            {

              Scaffold.of(context).showSnackBar(SnackBar(content: Text('your password is not correct')));


            }
          else
            {

              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Welcome Dear Admin, ' + result.data['name'])));

              setState(() {
                _adminIDTextEditingController.text="";
                _passwordditingController.text="";

              });

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UploadPage()));
            }






          });

    });



  }
}
