import 'package:MOrder/controllers/cart_controller.dart';
import 'package:MOrder/views/MAKEORDERS/signature_pad.dart';
import 'package:flutter/material.dart';
import 'package:MOrder/views/MATERIAL/mainDrawer.dart';
import 'package:get/get.dart';

class MakeOder extends StatefulWidget {
  @override
  _MakeOderState createState() => _MakeOderState();
}

class _MakeOderState extends State<MakeOder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          backgroundColor: Colors.orange,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Current',
              ),
              Tab(
                text: 'Summary',
              )
            ],
          ),
        ),
        drawer: MainDrawer(),
        body: TabBarView(
          children: [
            GetX<CartController>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title:
                                Text(controller.cartItems[index].productName),
                            subtitle: Text(
                                controller.cartItems[index].price.toString()),
                          );
                        },
                        itemCount: controller.cartItems.length,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignaturePad(),
                              ),
                            );
                          },
                          child: Text('Confirm Order')),
                    )
                  ],
                );
              },
            ),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
