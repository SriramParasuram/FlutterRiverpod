class Product {
  final int productId;
  final String name;
  final String category;
  final double price;
  final int stock;

  Product({
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json['product_id'],
    name: json['name'],
    category: json['category'],
    price: (json['price'] as num).toDouble(),
    stock: json['stock'],
  );
}