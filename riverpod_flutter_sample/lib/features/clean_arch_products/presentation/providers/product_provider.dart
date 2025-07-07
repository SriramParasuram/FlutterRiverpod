import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/network/dio_provider.dart';
import '../../domain/usecases/clear_local_cache.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/entities/product.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/datasources/product_local_datasource.dart';

//  Typed Hive Box Provider
final productBoxProvider = Provider<Box<ProductModel>>(
  (ref) => Hive.box<ProductModel>('productsBox'),
);

//  UseCase Provider with both Remote + Local Data Sources
final getAllProductsUseCaseProvider = Provider<GetAllProducts>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final remote = ProductRemoteDataSourceImpl(apiClient);

  final box = ref.read(productBoxProvider); //
  final local = ProductLocalDataSourceImpl(box);

  final repository = ProductRepositoryImpl(remote, local);
  return GetAllProducts(repository);
});

//  Actual Provider your UI will consume
final getAllProductsProvider = FutureProvider<List<Product>>((ref) async {
  print("get all products use case called");
  final useCase = ref.read(getAllProductsUseCaseProvider);
  return await useCase(); //
});

final clearCacheUseCaseProvider = Provider<ClearCache>((ref) {
  print("clear cache use case called");
  final apiClient = ref.read(apiClientProvider);
  final remote = ProductRemoteDataSourceImpl(apiClient);

  final box = ref.read(productBoxProvider);
  final local = ProductLocalDataSourceImpl(box);

  final repository = ProductRepositoryImpl(remote, local);
  return ClearCache(repository);
});
