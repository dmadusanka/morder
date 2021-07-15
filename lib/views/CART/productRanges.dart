import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:MOrder/views/CART/shoping_page.dart';

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
      body: Column(
        children: [
          Expanded(
            child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_){
                            // return mainDashBoard(newValue.id.toString());
                            return ShoppingPage();
                          }
                      ));
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    ),
                  );
                },
                itemCount: 20,
                staggeredTileBuilder: (index) => StaggeredTile.fit(1)
            ),
          )
        ],
      ),
    );
  }
}
