import 'package:flutter_hooks_riverpod_app/features/clean_arch_products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<void> clearCache();
}
