import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Widgets/searchBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  StoreHomeState createState() => StoreHomeState();
}

// Try to make function outside from class or make class public
class StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          MaterialPageRoute(builder: (context) => CartPage()));
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
                ))
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("items")
                  .limit(15)
                  .orderBy('publishedDate', descending: true)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data.documents[index].data);
                          return sourceInfo(model, context);
                        },
                        itemCount: dataSnapshot.data.documents.length);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget sourceInfo(ItemModel model, BuildContext context,
      {Color background, removeCartFunction}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ProductPage(itemModel: model)));
      },
      splashColor: Colors.pink,
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: Container(
          height: 190,
          width: width,
          child: Row(
            children: [
              Image.network(
                model.thumbnailUrl,
                width: 130,
                height: 150,
              ),
              SizedBox(
                width: 4.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                          model.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                          model.shortInfo,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.rectangle,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40,
                        height: 43,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '50%',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                'OFF',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  r'Origional Price: €',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                Text(
                                  (model.price + model.price).toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  r'New Price:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '€ ',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                ),
                                Text(
                                  (model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: removeCartFunction == null
                          ? IconButton(
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.pinkAccent,
                              ),
                              onPressed: () {
                                checkItemInCart(model.shortInfo, context);
                              })
                          : IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.pinkAccent,
                              ),
                              onPressed: null)),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
    return Container();
  }

  void checkItemInCart(String shortInfoAsID, BuildContext context)
   {
    EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList)
            .contains(shortInfoAsID)
        ? Fluttertoast.showToast(msg: 'Items already in cart')
        : addItemToCart(shortInfoAsID, context);
  }

  addItemToCart(String shortInfoAsID, BuildContext context) {
    List tempoCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempoCartList.add(shortInfoAsID);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempoCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: 'Items added to cart successfully');
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempoCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }
}
