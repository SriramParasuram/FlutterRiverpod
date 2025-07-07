import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;

  ProductRepositoryImpl(this.remote, this.local);

  @override
  Future<List<Product>> getAllProducts() async {
    print("flow number 2 - Checking cache");
    final cachedModels = await local.getCachedProducts();

    if (cachedModels.isNotEmpty) {
      print("flow number 3 - Using cached products");
      return cachedModels; // Already List<ProductModel> extends Product
    }

    print("flow number 5 - Fetching from remote API");
    final remoteProducts = await remote.getAllProducts();

    final modelsToCache = remoteProducts
        .map((e) => e as ProductModel)
        .toList();

    await local.cacheProducts(modelsToCache);
    print("flow number 6 - Cached remote products");

    return remoteProducts;
  }

  @override
  Future<void> clearCache() async {
    // TODO: implement clearCache
    local.clearCache();
    // throw UnimplementedError();
  }
}