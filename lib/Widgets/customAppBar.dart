import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
 
 
 final PreferredSizeWidget bottom;
 MyAppBar({this.bottom});
 
  @override
  Widget build(BuildContext context) {
    return AppBar(

       iconTheme: IconThemeData(

            color: Colors.white,






            
          ),

 flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pink, Colors.lightGreenAccent],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          centerTitle: true,
           title: Text(
            'e-Shop',
            style: TextStyle(
              fontSize: 55,
              color: Colors.white,
            ),
          ),
          bottom: bottom,
            actions: [
            Stack(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) =>
                           CartPage()));
                    }),
                Positioned(
                    child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 25,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 4,
                      bottom: 3,
                      left: 4.0,
                      child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                        return Text(
                          counter.coount.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        );
                      }),
                    )
                  ],
                )
                )
              ],
            )
          ],
          );
  
  }
  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):
  Size(56, 88+AppBar().preferredSize.height);
}
