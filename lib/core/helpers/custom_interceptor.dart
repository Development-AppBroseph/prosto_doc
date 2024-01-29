import 'package:dio/dio.dart';
import 'package:prosto_doc/core/helpers/helpers.dart';

class DatasourceInterceptor extends QueuedInterceptor {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      try {
        final String? token = await getStorageToken();
        if (token != null) {
          print('refresh token');
          // await refreshToken(token).then((value) async {
          //   String? refreshedToken = await getStorageToken();
          //   if (refreshedToken != null) {
          //     error.requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
          //     final response = await fetch(error.requestOptions);
          //     return handler.resolve(response);
          //   }
          // });
        }
      } catch (e) {
        super.onError(error, handler);
      }
    } else {
      super.onError(error, handler);
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getStorageToken();
    if (token == null) {
      print('token null');
      super.onRequest(options, handler);
    } else {
      print('token not null');
      final headers = options.headers;
      headers['Authorization'] = 'Bearer $token';
      super.onRequest(options.copyWith(headers: headers), handler);
    }
  }
}
