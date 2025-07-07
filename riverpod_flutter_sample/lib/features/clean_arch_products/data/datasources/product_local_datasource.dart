import 'package:hive/hive.dart';

import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box<ProductModel> box;

  ProductLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await box.clear(); // clear old entries
    for (var product in products) {
      await box.put(product.id, product); // use product.id as the key
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    return box.values.toList(); // retrieve all values
  }

  @override
  Future<void> clearCache() async {
    await box.clear();
  }
}

