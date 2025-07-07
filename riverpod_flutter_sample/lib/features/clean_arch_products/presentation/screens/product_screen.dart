import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    print("build method called!");
    final productAsyncValue = ref.watch(getAllProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products Clean Arch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Clear Cache & Refresh',
            onPressed: () async {
               final clearCache = ref.read(clearCacheUseCaseProvider);
               await clearCache(); //  Clear Hive
               ref.invalidate(getAllProductsProvider);

               // to check refresh functionality
               // final refresh= ref.refresh(getAllProductsProvider) ;
               // print("refresh state is ${refresh.value}");

            },
          ),
        ],
      ),
      body: productAsyncValue.when(
        data: (products) {
          print("listview is built again");
          return ListView.separated(
            itemCount: products.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductTile(product: product);
            },
          );
        },
        loading: () {
          print("loading state ??");
          return const Center(child: CircularProgressIndicator());
        },
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
