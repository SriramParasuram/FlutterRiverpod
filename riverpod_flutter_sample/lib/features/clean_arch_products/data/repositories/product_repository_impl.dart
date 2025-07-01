import 'package:flutter_hooks_riverpod_app/features/clean_arch_products/data/datasources/product_remote_datasource.dart';
import 'package:flutter_hooks_riverpod_app/features/clean_arch_products/domain/entities/product.dart';
import 'package:flutter_hooks_riverpod_app/features/clean_arch_products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductRepositoryImpl(this.productRemoteDataSource);

  @override
  Future<List<Product>> getAllProducts() async {
    // TODO: implement getAllProducts
    return await productRemoteDataSource.getAllProducts();
  }
}
