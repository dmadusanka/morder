import 'package:MOrder/models/salesOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOrder/controllers/cart_controller.dart';
import 'package:MOrder/controllers/shopping_controller.dart';
import 'package:MOrder/views/MAKEORDERS/makeOrders.dart';
import 'package:MOrder/models/product.dart';
//import 'package:charts_flutter/flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:badges/badges.dart';

class ShoppingPage extends StatelessWidget {
  final String categoryId;
  final int supplierId;

  ShoppingPage(this.categoryId, this.supplierId);

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
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return MakeOder(supplierId);
                    }));
                  }),
            )
          ],
          title: GetX<CartController>(
            builder: (controller) {
              return Text("\$ ${controller.totalPrice}");
            },
          ),
          backgroundColor: Colors.orange,
        ),
        //bottomNavigationBar: BottomBar(),
        body: FutureBuilder<List<Product>>(
          future: getProduct(categoryId),
          builder: (context, data) {
            if (data.hasData) {
              if (data.data.length == 0) {
                return Center(
                  child: Text('No Products for this Category'),
                );
              }
              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: data.data.length,
                    itemBuilder: (context, index) {
                      var imageIMAGE = data.data[index].productImage;
                      var baseURL =
                          'https://demo.msalesapp.com/msales/resources/getBlob/';
                      var imageURL = baseURL + imageIMAGE;
                      return Card(
                        margin: EdgeInsets.all(12),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          //padding: EdgeInsets.all(10.0),
                                          //color: Colors.orangeAccent,
                                          child: Text(
                                            '${data.data[index].productName}',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.orangeAccent),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                            '${data.data[index].productDescription}'),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          '\$ ${data.data[index].price}',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        ChangeNumber((quantity) {
                                          data.data[index].quantity = quantity;
                                        }),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Image.network(
                                      imageURL,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  cartControllert.addToCart(data.data[index]);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orangeAccent, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                child: Text("Add To Cart"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                  // Text("Total Amount \$"),
                  // SizedBox(height: 50.0,)
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Future<List<Product>> getProduct(String categoryId) async {
    final List<Product> products = [];

    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkJEU2pBYnRPYWhFMEQtSjFmTXZ6MyJ9.eyJodHRwczovL3d3dy5tc2FsZXMuY29tL2VtYWlsIjoiZHVsYW5qYW5zZWpAZ21haWwuY29tIiwiaHR0cHM6Ly93d3cubXNhbGVzLmNvbS9lbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDYwNzAwYzgyMGE0YjU1MDA2OTJkYjgyOSIsImF1ZCI6WyJodHRwOi8vcHVibGljLmFwaS5tc2FsZXNhcHAuY29tIiwiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTYyODU3OTM3OSwiZXhwIjoxNjI4NjY1Nzc5LCJhenAiOiJCN0ZObXV2ZVRjZG4zZWthcVQ3eU1PZUs0Szgwd1FpOCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwifQ.ZwOubU4BPm0NrjrjmYmHg1EN2nrpeEK6yw-f96jUZ66Mv2DCL6RziZtau0zVQkAEf-a4vVMOlBBCvMkaFM-w1DhVsTSMpd6oSWC2i1ke6ee2Pf_A1Iz9VkhuKvzXOrPz_X1A2vBVvORNdq6_RqQ6JJi3Ybq8YKRf8BwEwxtN1lRMymaSZdHfp0ifH92FVT5QefKgIPw9Nm4NuGEhYtgmwPoTi-JK04woCjOX0HLpJzf8D7pL1B2DdfbXHawd-Zu4aAHpZ5tJDy3-Jo2UITtmpWxiW4NIYgMa3C117Wdp5774Yr-wZVCwKXRXzVcrJp68hqOHvWYeVo6tlUok0WCl0Q',
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=B2E911507B6EE95774EC0246B10F5F5F',
      'BusinessId': 'partner-1'
    };

    var response = await http.get(
        Uri.parse(
            'https://api.msalesapp.com/API/V1/Products?CategoryId=$categoryId'),
        headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var allProducts = json.decode(response.body)["products"];
      print(allProducts);

      for (int i = 0; i < allProducts.length; i++) {
        products.add(Product.fromJson(allProducts[i]));
      }
    } else {
      print(response.reasonPhrase);
    }
    print(products.length);
    return products;
  }

  void getQuantity(int quantity) {}
}

class ChangeNumber extends StatefulWidget {
  final Function newCount;
  ChangeNumber(this.newCount);

  @override
  State<StatefulWidget> createState() {
    return _ChangeNumber();
  }
}

class _ChangeNumber extends State<ChangeNumber> {
  int _counter = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            if (_counter > 1) {
              setState(() {
                _counter--;
              });
              widget.newCount(_counter);
            }
          },
          icon: Icon(Icons.remove),
        ),
        Text(_counter.toString()),
        IconButton(
          onPressed: () {
            setState(() {
              _counter++;
            });
            widget.newCount(_counter);
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
