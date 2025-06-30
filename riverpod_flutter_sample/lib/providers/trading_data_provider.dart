// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../constants/app_constants.dart';
//
// final tradingDataProvider = FutureProvider<TradingData>((ref) async {
//   final responses = await Future.wait([
//     http.get(Uri.parse(AppConstants.productsUrl)),
//     http.get(Uri.parse(AppConstants.transactionsUrl)),
//     http.get(Uri.parse(AppConstants.usersUrl)),
//   ]);
//
//   return TradingData(
//     products: json.decode(responses[0].body),
//     transactions: json.decode(responses[1].body),
//     users: json.decode(responses[2].body),
//   );
// });
//
// class TradingData {
//   final Map<String, dynamic> products;
//   final Map<String, dynamic> transactions;
//   final Map<String, dynamic> users;
//
//   TradingData({
//     required this.products,
//     required this.transactions,
//     required this.users,
//   });
// }

// lib/providers/trading_data_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

final tradingDataProvider = FutureProvider<TradingData>((ref) async {
  print("trading data API called");
  final start = DateTime.now();
  final responses = await Future.wait([
    http.get(Uri.parse(AppConstants.productsUrl)),
    // http.get(Uri.parse(AppConstants.transactionsUrl)),
    // http.get(Uri.parse(AppConstants.usersUrl)),
  ]);

  final products = await compute(_parseJson, responses[0].body);
  // final transactions = await compute(_parseJson, responses[1].body);
  // final users = await compute(_parseJson, responses[2].body);


  return TradingData(
    products: json.decode(responses[0].body),
    transactions: json.decode(responses[1].body),
    users: json.decode(responses[2].body),
  );
});

Map<String, dynamic> _parseJson(String responseBody) {
  return json.decode(responseBody) as Map<String, dynamic>;
}

class TradingData {
  final Map<String, dynamic> products;
  final Map<String, dynamic> transactions;
  final Map<String, dynamic> users;

  TradingData({
    required this.products,
    required this.transactions,
    required this.users,
  });
}
