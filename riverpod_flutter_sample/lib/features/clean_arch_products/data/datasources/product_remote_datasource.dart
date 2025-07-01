import 'package:flutter/foundation.dart';
import 'package:flutter_hooks_riverpod_app/core/network/api_client.dart';
import 'package:flutter_hooks_riverpod_app/core/network/network_config.dart';
import 'package:flutter_hooks_riverpod_app/features/clean_arch_products/domain/entities/product.dart';

import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getAllProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  // @override
  // Future<List<Product>> getAllProducts() async {
  //   // TODO: implement getAllProducts
  //
  //   final response = await apiClient.get(NetworkConfig.getProducts,
  //       fromJson: (json) => ProductModel.fromJson(json));
  //
  //   // If your ApiClient handles the list mapping:
  //   // return response.map((e) => e as Product).toList();
  //
  //   // If not, and you receive raw list of maps:
  //   return (response as List)
  //       .map((json) => ProductModel.fromJson(json))
  //       .toList();
  // }

  @override
  Future<List<Product>> getAllProducts() async {
    final response = await apiClient.get(NetworkConfig.getProducts,
        fromJson: (json) => ProductModel.fromJson(json));

    // Assuming response is a List<dynamic>
    final productList = await compute(parseProducts, response as List);

    return productList;
  }

  List<Product> parseProducts(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }
}
