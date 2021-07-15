import 'package:MOrder/models/product.dart';
import 'package:get/state_manager.dart';

class CartController extends GetxController{
  var cartItems = List<Product>().obs;
  int get itemCount => cartItems.length;
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);

  addToCart(Product product){
    cartItems.add(product);
  }

}