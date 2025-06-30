import 'package:dio/dio.dart';

// Header Handling and all done in here 
class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add headers like auth token here
    options.headers['Content-Type'] = 'application/json';
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('Error: ${err.message}');
    return super.onError(err, handler);
  }
}