import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_result.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<ApiResult<T>> get<T>(
    String path, {
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await dio.get(path);

      print(" Raw HTTP response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        Map<String, dynamic> parsedJson;

        if (data is String) {
          parsedJson = json.decode(data) as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          parsedJson = data;
        } else {
          return Failure<T>(
            'Unexpected data type: ${data.runtimeType}',
          );
        }

        return Success<T>(fromJson(parsedJson));
      } else {
        return Failure<T>('Failed with status: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      return Failure<T>('Network error: ${dioError.message}');
    } catch (e) {
      return Failure<T>('Unexpected error: $e');
    }
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await dio.post(path, data: body);

      print(" Raw HTTP response (POST): ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        Map<String, dynamic> parsedJson;

        if (data is String) {
          parsedJson = json.decode(data) as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          parsedJson = data;
        } else {
          return Failure<T>('Unexpected data type: ${data.runtimeType}');
        }

        return Success<T>(fromJson(parsedJson));
      } else {
        return Failure<T>('Failed with status: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      return Failure<T>('Network error: ${dioError.message}');
    } catch (e) {
      return Failure<T>('Unexpected error: $e');
    }
  }
}
