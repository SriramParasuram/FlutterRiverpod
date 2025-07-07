import '../repositories/product_repository.dart';

class ClearCache {
  final ProductRepository repository;

  ClearCache(this.repository);

  Future<void> call() async {
    await repository.clearCache();
  }
}