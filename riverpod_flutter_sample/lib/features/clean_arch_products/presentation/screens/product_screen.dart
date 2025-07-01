import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Optional: Trigger refresh or logging here
  }

  @override
  Widget build(BuildContext context) {
    final productAsyncValue = ref.watch(getAllProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: productAsyncValue.when(
        data: (products) => ListView.separated(
          itemCount: products.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductTile(product: product);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading products\n$error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}