import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:e_shop/splashscreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _tileTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayUploadFormScreen();
  }

  displayAdminHomeScreen() {
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
        leading: IconButton(
            icon: Icon(Icons.border_color),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminShiftOrders()));
            }),
        actions: [
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            },
          )
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Add New Items',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: () => takeImage(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (cn) {
          return SimpleDialog(
            title: Text(
              'Item Image',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  ' Capture with camera',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  ' Select from Gallery',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  ' Cancel',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);

    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);

    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = imageFile;
    });
  }

  displayUploadFormScreen() {
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
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearFormInfo),
        title: Text(
          'New Product',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
          
              onPressed:  uploading ? null : () =>
              uploadImageAndSaveItemInfo()
              ,
              child: Text(
                'Add',
                style: TextStyle(
                    color: Colors.pink,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(''),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Short Info',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
           ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _tileTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
           ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
           ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Price  ',
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
        ],
      ),
    );
  }

  clearFormInfo() {

    setState(() {

      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _tileTextEditingController.clear();

      
    });



  }
  uploadImageAndSaveItemInfo()async{

   

   setState(() {
     uploading=true;
     
   });

  String imageDownloadUrl=await  uploadItemImage(file);

  saveItemInfo(imageDownloadUrl);



  }
 Future<String> uploadItemImage(mFileImage)async{

   final StorageReference storageReference=FirebaseStorage.instance
   .ref().child('Items');

   StorageUploadTask uploadTask=storageReference
   .child('product _$productId.jpg')
   .putFile(mFileImage);

   StorageTaskSnapshot taskSnapshot=
   await uploadTask.onComplete;
   String downloadUrl= await taskSnapshot.ref.getDownloadURL();

   return downloadUrl;





  }

  saveItemInfo(String  downloadUrl){
   final itemRef=Firestore.instance.collection('items');
   itemRef.document(productId).setData(
     {
       "shortInfo":_shortInfoTextEditingController.text.trim(),
       "longDescription":_descriptionTextEditingController.text.trim(),
       "price":int.parse(_priceTextEditingController.text),
       "publishedDate":DateTime.now(),
       "status":'available',
       "thumbnailUrl":downloadUrl,
       "title":_tileTextEditingController.text.trim(),

        


     });
  

  setState(() {
    file=null;
    uploading=false;
    productId=DateTime.now().millisecondsSinceEpoch.toString();
    _descriptionTextEditingController.clear();
    _tileTextEditingController.clear();
    _shortInfoTextEditingController.clear();
    _priceTextEditingController.clear();


    
  });


  }



  
}
