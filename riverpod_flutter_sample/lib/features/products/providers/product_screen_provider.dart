import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/product_model.dart';
import '../data/product_service.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;

  ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductService service;

  ProductNotifier(this.service) : super(ProductState());

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await service.fetchProducts();
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}

final productProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final service = ref.read(productServiceProvider);
  return ProductNotifier(service);
});
