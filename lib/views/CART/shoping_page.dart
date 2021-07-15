import 'package:MOrder/controllers/cart_controller.dart';
import 'package:MOrder/controllers/shopping_controller.dart';
import 'package:MOrder/views/MATERIAL/bottomBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingPage extends StatelessWidget {

  final shoppingController = Get.put(ShoppingController());
  final cartControllert = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<CartController>(builder: (controller){
          return Text("\$ ${controller.totalPrice}");
        },),
        backgroundColor: Colors.orange,
        actions: [
          GetX<CartController>(builder: (controller){
            return Stack(
              children: [
                IconButton(icon: Icon(Icons.add_shopping_cart_outlined), onPressed: (){print("Cart Cliked");}),
                Positioned(
                  child: Text('${controller.itemCount}', style: TextStyle(fontSize: 16),),
                  right: 50,
                  top: 0,
                )
              ],
            );
          },),
        ],
      ),
      bottomNavigationBar: BottomBar(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_shopping_cart_outlined),
        label: GetX<CartController>(builder: (controller){
          return Text('${controller.itemCount}',style: TextStyle(fontSize: 20));
        },),
        onPressed: (){
        },
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
              child: GetX<ShoppingController>(
                builder: (controller){
                  return ListView.builder(
                      itemCount: controller.products.length,
                      itemBuilder: (context, index){
                        return Card(
                          margin: EdgeInsets.all(12),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${controller.products[index].productName}'
                                        ),
                                        Text(
                                            '${controller.products[index].productDescription}'
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\$ ${controller.products[index].price}',
                                      style: TextStyle(fontSize: 18.0),
                                    )
                                  ],
                                ),
                                RaisedButton(
                                    onPressed: (){
                                      cartControllert.addToCart(controller.products[index]);
                                    },
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Text("Add To Cart"),
                                )
                              ],
                            ),
                          ),
                        );
                  });
                },
              )
          ),
          // Text("Total Amount \$"),
          // SizedBox(height: 50.0,)
        ],
      ),
    );
  }
}
