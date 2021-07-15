import 'package:MOrder/controllers/cart_controller.dart';
import 'package:MOrder/controllers/shopping_controller.dart';
import 'package:MOrder/models/product.dart';
import 'package:MOrder/views/MATERIAL/bottomBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShoppingPage extends StatelessWidget {
  final String categoryId;

  ShoppingPage(this.categoryId);

  final shoppingController = Get.put(ShoppingController());
  final cartControllert = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GetX<CartController>(
            builder: (controller) {
              return Text("\$ ${controller.totalPrice}");
            },
          ),
          backgroundColor: Colors.orange,
          actions: [
            GetX<CartController>(
              builder: (controller) {
                return Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.add_shopping_cart_outlined),
                        onPressed: () {
                          print("Cart Cliked");
                        }),
                    Positioned(
                      child: Text(
                        '${controller.itemCount}',
                        style: TextStyle(fontSize: 16),
                      ),
                      right: 50,
                      top: 0,
                    )
                  ],
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add_shopping_cart_outlined),
          label: GetX<CartController>(
            builder: (controller) {
              return Text('${controller.itemCount}',
                  style: TextStyle(fontSize: 20));
            },
          ),
          onPressed: () {},
          backgroundColor: Colors.orange,
        ),
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
                      return Card(
                        margin: EdgeInsets.all(12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
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
                                        Text('${data.data[index].productName}'),
                                        Text(
                                            '${data.data[index].productDescription}'),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$ ${data.data[index].price}',
                                    style: TextStyle(fontSize: 18.0),
                                  )
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  cartControllert.addToCart(data.data[index]);
                                },
                                child: Text("Add To Cart"),
                              )
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
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkJEU2pBYnRPYWhFMEQtSjFmTXZ6MyJ9.eyJodHRwczovL3d3dy5tc2FsZXMuY29tL2VtYWlsIjoiZHVsYW5qYW5zZWpAZ21haWwuY29tIiwiaHR0cHM6Ly93d3cubXNhbGVzLmNvbS9lbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDYwNzAwYzgyMGE0YjU1MDA2OTJkYjgyOSIsImF1ZCI6WyJodHRwOi8vcHVibGljLmFwaS5tc2FsZXNhcHAuY29tIiwiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTYyNjM1NTk4NiwiZXhwIjoxNjI2NDQyMzg2LCJhenAiOiJCN0ZObXV2ZVRjZG4zZWthcVQ3eU1PZUs0Szgwd1FpOCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwifQ.Dr3utpWNJ9m7aPXgjjLPubL83Q1GgtD78hIm_yAKAfjHeO8g7LwDklSOBvfLsWsW55yP7ZXfgPNvMAlt8AoIXB1C4r8r0Zo8nJccgOfn5rvZHx8UG13HPh2_rr-zNgHMTRXzYjI7H3YkfOv0BJUikKeJ57j7quGNzykvWqoMHgS06gKgrj0wdztCofd4z9-3Cs9Z9Y7Ir7-TSRGXHZCX-aMEol3aNOGwE9QdubgBJJ3YeW5hjoJ3HQGf804quUC0r6cl5vM-7PVfrmDWo9lR4fPnkHg8HvNZr2mVvzGFrt_5qNOtuqH64_Q1kQv4Dp4HSBeenvZG1FwsbYbGkA47oQ',
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
}
