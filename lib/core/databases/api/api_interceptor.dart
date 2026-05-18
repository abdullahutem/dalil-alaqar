import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  final CacheHelper cacheHelper;

  ApiInterceptor({required this.cacheHelper});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = cacheHelper.getData(key: ApiKey.token);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
