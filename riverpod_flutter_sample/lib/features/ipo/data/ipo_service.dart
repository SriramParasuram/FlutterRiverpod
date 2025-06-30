

import 'package:flutter_hooks_riverpod_app/core/network/api_result.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/network_config.dart';
import 'iporesponse.dart';

class IpoService {
  final ApiClient apiClient;

  IpoService(this.apiClient);

  Future<IpoResponse> fetchIpoDataFromService() async {
    print("my actual api service called");
    final result = await apiClient.get(
      NetworkConfig.getIPOs,
      fromJson: (json) => IpoResponse.fromJson(json),
    );

    return result.when(
      success: (data) => data,
      failure: (e) => throw Exception("API failed: ${e}"),
    );
  }
}
