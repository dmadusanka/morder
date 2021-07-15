class Product {
  final String id;
  final String productName;
  final productImage;
  final productDescription;
  final double price;

  Product(this.id, this.productName, this.price, this.productDescription,
      this.productImage);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['id'], json['name'], json['pricing'][0]['price'],
        json['description'], '');
  }
}
