import 'package:MOrder/models/sales_order_summary.dart';
import 'package:MOrder/views/MAKEORDERS/orderHistoryItrms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart';
import 'package:MOrder/controllers/shopping_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:MOrder/controllers/cart_controller.dart';

import '../MATERIAL/mainDrawer.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
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
            badgeContent: GetX<CartController>(
              builder: (controller) {
                return Text(
                  '${controller.itemCount}',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                );
              },
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
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
      body: FutureBuilder<List<SalesOrderSummary>>(
        future: getSalesSummary(),
        builder: (context, snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData) {
            print(snapshot.data.length);
            var data = snapshot.data;
            return Column(
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
                                title: Text(
                                    "Order ID : ${data[index].internalId}"),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Order Total : ${data[index].orderTotal}",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.blue),
                                    ),
                                    const SizedBox(width: 8),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Note : ${data[index].notes}",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                      ),
                                      child: Text('Show Items'),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return OrderHistoryItems(
                                              data[index].orderItems);
                                        }));
                                        //cartControllert.removeProduct(controller.cartItems[index]);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: data.length,
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<SalesOrderSummary>> getSalesSummary() async {
    List<SalesOrderSummary> salesOrderSummary = [];

    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkJEU2pBYnRPYWhFMEQtSjFmTXZ6MyJ9.eyJodHRwczovL3d3dy5tc2FsZXMuY29tL2VtYWlsIjoiZHVsYW5qYW5zZWpAZ21haWwuY29tIiwiaHR0cHM6Ly93d3cubXNhbGVzLmNvbS9lbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDYwNzAwYzgyMGE0YjU1MDA2OTJkYjgyOSIsImF1ZCI6WyJodHRwOi8vcHVibGljLmFwaS5tc2FsZXNhcHAuY29tIiwiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTYyODU3OTM3OSwiZXhwIjoxNjI4NjY1Nzc5LCJhenAiOiJCN0ZObXV2ZVRjZG4zZWthcVQ3eU1PZUs0Szgwd1FpOCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwifQ.ZwOubU4BPm0NrjrjmYmHg1EN2nrpeEK6yw-f96jUZ66Mv2DCL6RziZtau0zVQkAEf-a4vVMOlBBCvMkaFM-w1DhVsTSMpd6oSWC2i1ke6ee2Pf_A1Iz9VkhuKvzXOrPz_X1A2vBVvORNdq6_RqQ6JJi3Ybq8YKRf8BwEwxtN1lRMymaSZdHfp0ifH92FVT5QefKgIPw9Nm4NuGEhYtgmwPoTi-JK04woCjOX0HLpJzf8D7pL1B2DdfbXHawd-Zu4aAHpZ5tJDy3-Jo2UITtmpWxiW4NIYgMa3C117Wdp5774Yr-wZVCwKXRXzVcrJp68hqOHvWYeVo6tlUok0WCl0Q',
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=B2E911507B6EE95774EC0246B10F5F5F',
      'BusinessId': 'partner-1'
    };

    var response = await http.get(
        Uri.parse('https://api.msalesapp.com/API/V1/SalesOrders'),
        headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var salesOrders = json.decode(response.body)["salesOrders"];
      print(salesOrders);

      for (int i = 0; i < salesOrders.length; i++) {
        salesOrderSummary.add(SalesOrderSummary.fromJson(salesOrders[i]));
      }
    } else {
      print(response.reasonPhrase);
    }
    // print(salesOrderSummary.length);
    return salesOrderSummary;
  }
}
