import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/entities/product.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/datasources/product_remote_datasource.dart';

// Provider to construct the usecase with all dependencies
final getAllProductsUseCaseProvider = Provider<GetAllProducts>((ref) {
  final apiClient = ref.read(apiClientProvider); // your core network layer
  final dataSource = ProductRemoteDataSourceImpl(apiClient);
  final repository = ProductRepositoryImpl(dataSource);
  return GetAllProducts(repository);
});

// The actual FutureProvider that your UI will use
final getAllProductsProvider = FutureProvider<List<Product>>((ref) async {
  final useCase = ref.read(getAllProductsUseCaseProvider);
  return await useCase(); // Executes the usecase
});
