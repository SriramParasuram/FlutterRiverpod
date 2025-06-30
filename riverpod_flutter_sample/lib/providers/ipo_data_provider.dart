
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';
import '../constants/app_constants.dart';
import '../features/ipo/data/iporesponse.dart';

final iPODataProvider = FutureProvider<IpoResponse>((ref) async {
  // print("📡 IPO API fetching...");
  final response = await http.get(Uri.parse(AppConstants.iPOUrl));
  final Map<String, dynamic> jsonData = json.decode(response.body);
  print("json data is $jsonData");
  return IpoResponse.fromJson(jsonData);

});


