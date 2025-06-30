import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/ipo_data_provider.dart';
import '../providers/trading_data_provider.dart';
import '../constants/app_constants.dart';

class MyDetailPage extends HookConsumerWidget {
  const MyDetailPage({super.key});

  Widget buildExpandableTable({
    required String title,
    required List<Map<String, dynamic>> data,
    required List<String> columns,
    required List<String> keys,
  }) {
    return ExpansionTile(
      title: Text('$title (${data.length})'),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
            rows: data.map((row) {
              return DataRow(
                cells: keys.map((key) => DataCell(Text('${row[key]}'))).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("products data page reached!!!");
    final tradingData = ref.watch(tradingDataProvider);

    // useEffect(() {
    //   Future.microtask(() {
    //     // debugPrint('⏳ Invalidating tradingDataProvider...');
    //     // ref.invalidate(tradingDataProvider);
    //     // final tradingData = ref.refresh(tradingDataProvider);
    //   });
    //   return null;
    // }, []);


    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.detailPageTitle)),
      body: tradingData.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.green,)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bundle) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              buildExpandableTable(
                title: 'Users',
                data: List<Map<String, dynamic>>.from(bundle.users['users'] ?? []).take(10).toList(),
                columns: ['ID', 'Name', 'Email', 'Age', 'Active'],
                keys: ['id', 'name', 'email', 'age', 'is_active'],
              ),
              buildExpandableTable(
                title: 'Transactions',
                data: List<Map<String, dynamic>>.from(bundle.transactions['transactions'] ?? []).take(10).toList(),
                columns: ['Txn ID', 'User ID', 'Amount', 'Currency', 'Status', 'Timestamp'],
                keys: ['txn_id', 'user_id', 'amount', 'currency', 'status', 'timestamp'],
              ),
              buildExpandableTable(
                title: 'Products',
                data: List<Map<String, dynamic>>.from(bundle.products['products'] ?? []).take(10).toList(),
                columns: ['Product ID', 'Name', 'Category', 'Price', 'Stock'],
                keys: ['product_id', 'name', 'category', 'price', 'stock'],
              ),
            ],
          );
        },
      ),
    );
  }
}
