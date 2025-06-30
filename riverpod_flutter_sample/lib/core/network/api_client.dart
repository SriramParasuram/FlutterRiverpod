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

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          return Success<T>(fromJson(data));
        } else {
          return Failure<T>(
              'Expected JSON object but got: ${data.runtimeType}');
        }
      } else {
        return Failure<T>('Failed with status: ${response.statusCode}');
      }
    } on DioError catch (dioError) {
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

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          return Success<T>(fromJson(data));
        } else {
          return Failure<T>(
              'Expected JSON object but got: ${data.runtimeType}');
        }
      } else {
        return Failure<T>('Failed with status: ${response.statusCode}');
      }
    } on DioError catch (dioError) {
      return Failure<T>('Network error: ${dioError.message}');
    } catch (e) {
      return Failure<T>('Unexpected error: $e');
    }
  }
}
