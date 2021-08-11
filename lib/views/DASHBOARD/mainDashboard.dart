import 'package:flutter/material.dart';
import 'package:MOrder/views/MATERIAL/mainDrawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:MOrder/views/MATERIAL/bottomBar.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:MOrder/controllers/shopping_controller.dart';
import 'package:MOrder/controllers/cart_controller.dart';
import 'package:MOrder/views/MAKEORDERS/makeOrders.dart';

class MainDashBoard extends StatefulWidget {
  final int productName;

  const MainDashBoard(this.productName);

  @override
  _MainDashBoardState createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {
  List<charts.Series<Products, String>> _seriesBarData;
  _generateData() {
    var barData = [
      new Products("Cookies", 19.5, Colors.lightBlueAccent),
      new Products("Cakes", 37.0, Colors.orangeAccent),
      new Products("Fruits", 49.0, Colors.lightGreenAccent),
      new Products("Chocolate", 67.8, Colors.lightBlueAccent),
    ];

    _seriesBarData.add(
      charts.Series(
          data: barData,
          domainFn: (Products products, _) => products.Targer_v,
          measureFn: (Products products, _) => products.Achieved_v,
          colorFn: (Products products, _) =>
              charts.ColorUtil.fromDartColor(products.color_v),
          id: "Daily Income",
          labelAccessorFn: (Products products, _) => '${products.Achieved_v}'),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesBarData = List<charts.Series<Products, String>>();
    _generateData();
  }

  Material myItems(IconData icon, String headline, int color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(14.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        (headline),
                        style: TextStyle(color: Color(color), fontSize: 14.0),
                      ),
                    ),
                  ),
                  Material(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final shoppingController = Get.put(ShoppingController());
  final cartControllert = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Badge(
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeColor: Colors.deepOrange,
            badgeContent: GetX<CartController>(
              builder: (controller) {
                return Text('${controller.itemCount}',
                  style: TextStyle(fontSize: 15,color: Colors.white),);
              },
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return MakeOder(1);
                  }));
                }
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Container(
        child: Center(
          child: Text("No Top Selling Products to show"),
        ),
      ),
    );
  }
}

class Products {
  String Targer_v;
  double Achieved_v;
  Color color_v;

  Products(this.Targer_v, this.Achieved_v, this.color_v);
}
