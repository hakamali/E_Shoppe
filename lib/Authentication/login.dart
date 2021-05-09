import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Store/store_home.dart';
import 'package:e_shop/Widgets/CustomTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _passwordditingController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenhieght = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/login.png',
                height: 240,
                width: 240,
              ),


            ),
            Padding(
                padding: EdgeInsets.all(8.0 ),
              child: Text('Login to your account',
                style: TextStyle(
                  color: Colors.white




                ),
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [

                    CustomTextField(
                      controller: _emailditingController,
                      data:Icons.email,
                      hintText:'Email' ,
                      isObsecure: false,


                    ),
                    CustomTextField(
                      controller: _passwordditingController,
                      data:Icons.person,
                      hintText:'Password' ,
                      isObsecure: true,


                    ),


                  ],



                )),
            RaisedButton(
              onPressed: (){

                _emailditingController.text.isNotEmpty &&
                    _passwordditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                    context: context,
                  builder: (c){
                      return ErrorAlertDialog(
                        message: 'Please write email and password ',

                      );



                  }
                );

              },
              color: Colors.pink,
              child: Text('login',
                style:TextStyle(
                    color: Colors.white



                ) ,


              ),

            ),
            SizedBox(
              height:50 ,


            ),
            Container(
              height: 4,
              width: _screenwidth *0.8,
              color: Colors.pink,

            ),
            SizedBox(
              height:10,


            ),
            FlatButton.icon(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>AdminSignInPage()
                  ));
                  
                },
                icon: Icon(Icons.nature_people, color: Colors.pink,),
                label: Text('I am admin',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold


                  ),
                )
            )


          ],



        )

      ),


    );
  }
  FirebaseAuth _auth=FirebaseAuth.instance;
  void loginUser()async{
    showDialog(context: context,
      builder: (c){

      return LoadingAlertDialog(message: 'Authenticating ,Please wait');
      }
    );

    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
        email: _emailditingController.text.trim(),
        password: _passwordditingController.text.trim()
    ).then((authUser){
      firebaseUser=authUser.user;



    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){

            return ErrorAlertDialog(message: error.message.toString(),);

          }
      );


    });
    if(firebaseUser !=null)
      {

      readData(firebaseUser).then((s){
        Navigator.pop(context);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StoreHome()));


      });

      }



  }
 Future readData(FirebaseUser fUser)async{
   Firestore.instance.collection('users').document(fUser.uid)
       .get()
       .then((dataSnapshot)
   async {
     await EcommerceApp.sharedPreferences.setString('uid', dataSnapshot.data[EcommerceApp.userUID]);
     await EcommerceApp.sharedPreferences.setString(
         EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
     await EcommerceApp.sharedPreferences.setString(
         EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
     await EcommerceApp.sharedPreferences.setString(
         EcommerceApp.userAvatarUrl,dataSnapshot.data[EcommerceApp.userAvatarUrl]);
     List<String> cartList=dataSnapshot.data[EcommerceApp.userCartList]
     .cast<String>();
     await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartList);

   });
 }
}
