import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks_riverpod_app/core/network/api_client.dart';
import 'package:flutter_hooks_riverpod_app/core/network/network_config.dart';
import 'package:flutter_hooks_riverpod_app/features/clean_arch_products/domain/entities/product.dart';
import '../../../../core/network/api_result.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getAllProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<Product>> getAllProducts() async {
    print("flow number 3");
    print(" API called - Should not see this if cached");

    final result = await apiClient.get<String>(
      NetworkConfig.getProducts,
      fromJson: (json) => jsonEncode(json), // encode raw json to String for compute
    );

    print(" API result: $result");

    if (result is Success<String>) {
      final products = await compute(parseProductsFromJson, result.data);
      return products;
    } else if (result is Failure) {
      throw Exception('API Error: $result');
    } else {
      throw Exception('Unknown API result');
    }
  }
}

/// compute-safe parsing method
List<Product> parseProductsFromJson(String rawJson) {
  try {
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final list = decoded['products'] as List<dynamic>;

    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e, st) {
    print(" Error parsing products in isolate: $e");
    print(" Stacktrace: $st");
    return [];
  }
}