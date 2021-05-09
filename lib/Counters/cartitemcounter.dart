import 'package:flutter/foundation.dart';
import 'package:e_shop/Config/config.dart';

class CartItemCounter extends ChangeNotifier{


  int  _counter=EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)
      .length-1;
  int get coount => _counter;

 Future<void> displayResult()async{
         int  _counter=EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)
      .length-1;

   await Future.delayed(const Duration(milliseconds:100 ),
   
      (){

        notifyListeners();



      }
   );
  }
}