import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ItemQuantity with ChangeNotifier {


  int _numberOfItems=0;

  int get numberOfItems => _numberOfItems;
  delay(int no)
  {

   _numberOfItems=no;
   notifyListeners();
   


  }
}
