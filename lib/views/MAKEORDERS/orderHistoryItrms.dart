import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart';
import 'package:MOrder/controllers/shopping_controller.dart';
import 'package:MOrder/controllers/cart_controller.dart';

import '../MATERIAL/mainDrawer.dart';

class OrderHistoryItems extends StatefulWidget {
  @override
  _OrderHistoryItemsState createState() => _OrderHistoryItemsState();
}

class _OrderHistoryItemsState extends State<OrderHistoryItems> {
  final shoppingController = Get.put(ShoppingController());
  final cartControllert = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Badge(
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeContent:GetX<CartController>(
              builder: (controller) {
                return Text('${controller.itemCount}',
                  style: TextStyle(fontSize: 15, color: Colors.white),);
              },
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white,),
              // onPressed: () {
              //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              //     return MakeOder();
              //   }));
              // }
            ),
          )
        ],
        title: GetX<CartController>(
          builder: (controller) {
            return Text("Total: \$ ${controller.totalPrice}");
          },
        ),
        backgroundColor: Colors.orange,
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  child: Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: Column(
                      children: [
                        ListTile(
                          //title: Text(controller.cartItems[index].productName, style: TextStyle(fontSize: 20.0),),
                          title: Text("Order ID"),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Order Total",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.blue
                                ),),
                              const SizedBox(width: 8),
                              const SizedBox(width: 8),
                              Text("Note", style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
