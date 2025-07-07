import 'package:flutter/material.dart';
import 'package:flutter_hooks_riverpod_app/features/products/providers/product_screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_model.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  @override
  void initState() {
    print("init state called ??");
    super.initState();
    Future.microtask(() => ref.read(productProvider.notifier).loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Products (1000 items)")),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text("Error: ${state.error}"))
              : state.products.isEmpty
                  ? const Center(child: Text("No products available"))
                  : ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final Product product = state.products[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text(
                                "${product.category} • ₹${product.price.toStringAsFixed(2)}"),
                            trailing: Text("Stock: ${product.stock}"),
                          ),
                        );
                      },
                    ),
    );
  }
}
