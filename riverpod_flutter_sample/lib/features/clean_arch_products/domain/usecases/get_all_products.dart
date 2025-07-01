import 'package:flutter_hooks_riverpod_app/features/clean_arch_products/domain/entities/product.dart';

import '../repositories/product_repository.dart';

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);
  Future<List<Product>> call(){
    return repository.getAllProducts();
  }
}
