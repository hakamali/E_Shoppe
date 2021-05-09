import 'package:e_shop/Orders/searchProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent
      ) =>
      InkWell(
          onTap: (){
   Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SearchProduct()));


          },
        child: Container(
           

 decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pink, Colors.lightGreenAccent],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)
            ),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 10,right:10),


            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0)








            ),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(
                  left: 8.0

                ),
                child: Icon(
                  Icons.search,
                  color: Colors.blueGrey,


                ),
                
                
                ),

Padding(
  padding: EdgeInsets.only(left: 8.0),
  child: Text('Search here'),
  
  
  )






              ],








            ),






              ),






            ),








        ),
      );



  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}


