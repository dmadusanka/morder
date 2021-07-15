import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:MOrder/views/CART/shoping_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllProductRanges extends StatefulWidget {
  @override
  _AllProductRangesState createState() => _AllProductRangesState();
}

class _AllProductRangesState extends State<AllProductRanges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product Ranges'),
          backgroundColor: Colors.orange,
        ),
        body: FutureBuilder<List<ProductCategories>>(
          future: getProductCategories(),
          builder: (context, data) {
            if (data.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                // return mainDashBoard(newValue.id.toString());
                                return ShoppingPage(data.data[index].id);
                              }));
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.red,
                              child: Text(data.data[index].name),
                            ),
                          );
                        },
                        itemCount: data.data.length,
                        staggeredTileBuilder: (index) => StaggeredTile.fit(1)),
                  )
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Future<List<ProductCategories>> getProductCategories() async {
    final List<ProductCategories> productCategories = [];

    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkJEU2pBYnRPYWhFMEQtSjFmTXZ6MyJ9.eyJodHRwczovL3d3dy5tc2FsZXMuY29tL2VtYWlsIjoiZHVsYW5qYW5zZWpAZ21haWwuY29tIiwiaHR0cHM6Ly93d3cubXNhbGVzLmNvbS9lbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDYwNzAwYzgyMGE0YjU1MDA2OTJkYjgyOSIsImF1ZCI6WyJodHRwOi8vcHVibGljLmFwaS5tc2FsZXNhcHAuY29tIiwiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTYyNjM1NTk4NiwiZXhwIjoxNjI2NDQyMzg2LCJhenAiOiJCN0ZObXV2ZVRjZG4zZWthcVQ3eU1PZUs0Szgwd1FpOCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwifQ.Dr3utpWNJ9m7aPXgjjLPubL83Q1GgtD78hIm_yAKAfjHeO8g7LwDklSOBvfLsWsW55yP7ZXfgPNvMAlt8AoIXB1C4r8r0Zo8nJccgOfn5rvZHx8UG13HPh2_rr-zNgHMTRXzYjI7H3YkfOv0BJUikKeJ57j7quGNzykvWqoMHgS06gKgrj0wdztCofd4z9-3Cs9Z9Y7Ir7-TSRGXHZCX-aMEol3aNOGwE9QdubgBJJ3YeW5hjoJ3HQGf804quUC0r6cl5vM-7PVfrmDWo9lR4fPnkHg8HvNZr2mVvzGFrt_5qNOtuqH64_Q1kQv4Dp4HSBeenvZG1FwsbYbGkA47oQ',
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=B2E911507B6EE95774EC0246B10F5F5F',
      'BusinessId': 'partner-1'
    };

    var response = await http.get(
        Uri.parse('https://api.msalesapp.com/API/V1/ProductCategories'),
        headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var allProductCategories =
          json.decode(response.body)["productCategories"];
      print(allProductCategories);

      for (int i = 0; i < allProductCategories.length; i++) {
        productCategories
            .add(ProductCategories.fromJson(allProductCategories[i]));
      }
    } else {
      print(response.reasonPhrase);
    }
    print(productCategories.length);
    return productCategories;
  }
}

class ProductCategories {
  final String id;
  final String name;

  ProductCategories(this.id, this.name);

  factory ProductCategories.fromJson(Map<String, dynamic> json) {
    return ProductCategories(json['id'], json['name']);
  }
}
