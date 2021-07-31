import 'dart:async';

import 'package:MOrder/models/product.dart';
import 'package:MOrder/models/salesOrder.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignaturePad extends StatefulWidget {
  final List<Product> cartItems;
  final int supplierId;
  final double totalPrice;

  SignaturePad(this.cartItems, this.supplierId, this.totalPrice);

  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final StreamController<OrderState> _controller =
      StreamController<OrderState>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Container(
                child: SfSignaturePad(
                  minimumStrokeWidth: 2,
                  maximumStrokeWidth: 5,
                  strokeColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<OrderState>(
                    stream: _controller.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == OrderState.Loading) {
                          return Center(
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()));
                        }
                      }
                      return ElevatedButton(
                        child: Text('Done'),
                        onPressed: () async {
                          await addOrder();
                        },
                      );
                    }),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  Future<void> addOrder() async {
    _controller.add(OrderState.Loading);
    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkJEU2pBYnRPYWhFMEQtSjFmTXZ6MyJ9.eyJodHRwczovL3d3dy5tc2FsZXMuY29tL2VtYWlsIjoiZHVsYW5qYW5zZWpAZ21haWwuY29tIiwiaHR0cHM6Ly93d3cubXNhbGVzLmNvbS9lbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDYwNzAwYzgyMGE0YjU1MDA2OTJkYjgyOSIsImF1ZCI6WyJodHRwOi8vcHVibGljLmFwaS5tc2FsZXNhcHAuY29tIiwiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTYyNzcxODIwOSwiZXhwIjoxNjI3ODA0NjA5LCJhenAiOiJCN0ZObXV2ZVRjZG4zZWthcVQ3eU1PZUs0Szgwd1FpOCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwifQ.Wymcn_qdPQTCoRdy-89cvD5ASSb_SMsff8AJFd7EbvLmX7stOlVHpFmYtfNCZ5bfNF5wnFH3yiy6fmgirNp0EuYqSDBnwnZAeK-2-j9p2xhl4NKM-XAA255plzQMkRl46j27BfBso7GocEe0ma_vgJI5BdvdUvECdxnVRhe4wBtlJ8quXa2mojMvK0eCNy_bmQ-fIF2cK-ESIRCtPSQoYPRvUoXCk_N7Bp4xI_Onwi0918G_4H6fN07w399XAGB799cdurEOgGrUZW0dcA7vpfiH3GZPP3cXqTzlpkcOMj6RnX59eseo640z8C4mZG4tc8ejwHOHDXEqTAw8sjHsyA',
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=B2E911507B6EE95774EC0246B10F5F5F',
      'BusinessId': 'partner-1'
    };

    var salesOrder = SalesOrder(
      referenceId: "generated33333",
      captureTime: DateTime.now().toUtc().toIso8601String(),
      channel: "MORDER",
      creationLatitiude: 0,
      creationLongitude: 0,
      notes: '',
      customerId: 13,
      orderSubTotal: widget.totalPrice,
      taxSubTotal: widget.totalPrice / 10,
      orderTotal: widget.totalPrice + (widget.totalPrice / 10),
      items: widget.cartItems
          .map<Items>((e) => Items(
              productCode: e.id,
              description: e.productDescription,
              quantity: e.quantity,
              unitPrice: e.price,
              taxRate: 10,
              taxCode: 'GST',
              subTotalPrice: (e.price * e.quantity),
              subTotalTax: (e.price * e.quantity) / 10))
          .toList(),
    );

    var response = await http.post(
        Uri.parse('http://api.msalesapp.com/API/V1/SalesOrders'),
        body: json.encode(
          salesOrder.toJson(),
        ),
        headers: headers);

    print(json.encode(salesOrder.toJson()));
    if (response.statusCode == 200) {
      print(response.body);
      _controller.add(OrderState.Loaded);
      SnackBar snackBar = SnackBar(content: Text('Successfully Ordered'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print(response.reasonPhrase);
    }
  }
}

enum OrderState { Initial, Loading, Loaded }
