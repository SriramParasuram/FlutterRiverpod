import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks_riverpod_app/features/products/data/product_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiUrl =
      'https://pastebin.com/raw/vdjHueCR';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return compute(parseProducts, response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}

// ✅ Runs in a separate isolate using `compute()`
List<Product> parseProducts(String responseBody) {
  final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
  final productsJson = decoded['products'] as List<dynamic>;
  return productsJson.map((e) => Product.fromJson(e)).toList();
}

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});
