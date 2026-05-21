import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baserUrl;

    // تفعيل الطباعة التفصيلية لجميع العمليات
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('🔵 DIO LOG: $obj'),
      ),
    );

    // Add interceptor to include auth token in all requests
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('📤 REQUEST STARTED');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('🔗 URL: ${options.baseUrl}${options.path}');
          print('📍 Method: ${options.method}');
          print('⏰ Time: ${DateTime.now()}');

          // Get token from SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');

          // Add token to headers if it exists
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print('🔑 Token: ${token.substring(0, 20)}...');
          } else {
            print('⚠️  No Token Found');
          }

          // Add default headers
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';

          print('📋 Headers:');
          options.headers.forEach((key, value) {
            if (key.toLowerCase() != 'authorization') {
              print('   $key: $value');
            }
          });

          if (options.queryParameters.isNotEmpty) {
            print('🔍 Query Parameters:');
            options.queryParameters.forEach((key, value) {
              print('   $key: $value');
            });
          }

          if (options.data != null) {
            print('📦 Request Body:');
            try {
              final prettyJson = JsonEncoder.withIndent(
                '  ',
              ).convert(options.data);
              print(prettyJson);
            } catch (e) {
              print('   ${options.data}');
            }
          }
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('✅ RESPONSE RECEIVED');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print(
            '🔗 URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}',
          );
          print('📍 Method: ${response.requestOptions.method}');
          print('📊 Status Code: ${response.statusCode}');
          print('📝 Status Message: ${response.statusMessage}');
          print('⏰ Time: ${DateTime.now()}');

          if (response.headers.map.isNotEmpty) {
            print('📋 Response Headers:');
            response.headers.map.forEach((key, value) {
              print('   $key: ${value.join(", ")}');
            });
          }

          print('📦 Response Body:');
          try {
            final prettyJson = JsonEncoder.withIndent(
              '  ',
            ).convert(response.data);
            print(prettyJson);
          } catch (e) {
            print('   ${response.data}');
          }
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

          return handler.next(response);
        },
        onError: (error, handler) {
          print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('❌ ERROR OCCURRED');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print(
            '🔗 URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}',
          );
          print('📍 Method: ${error.requestOptions.method}');
          print('⏰ Time: ${DateTime.now()}');
          print('🚨 Error Type: ${error.type}');
          print('💬 Error Message: ${error.message}');

          if (error.response != null) {
            print('📊 Status Code: ${error.response?.statusCode}');
            print('📝 Status Message: ${error.response?.statusMessage}');
            print('📦 Error Response:');
            try {
              final prettyJson = JsonEncoder.withIndent(
                '  ',
              ).convert(error.response?.data);
              print(prettyJson);
            } catch (e) {
              print('   ${error.response?.data}');
            }
          } else {
            print('⚠️  No Response Data (Connection Error?)');
          }
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

          return handler.next(error);
        },
      ),
    );
  }

  //!POST
  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      print('\n🟢 POST Request Starting...');
      print('Path: $path');

      var res = await dio.post(
        path,
        data: isFormData && data is! FormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );

      print('🟢 POST Request Completed Successfully');
      print('Response Type: ${res.data.runtimeType}');

      return res.data;
    } on DioException catch (e) {
      print('🔴 POST Request Failed');
      print('Error: ${e.message}');
      handleDioException(e);
    }
  }

  //!GET
  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('\n🟢 GET Request Starting...');
      print('Path: $path');

      var res = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      print('🟢 GET Request Completed Successfully');
      print('Response Type: ${res.data.runtimeType}');

      return res.data;
    } on DioException catch (e) {
      print('🔴 GET Request Failed');
      print('Error: ${e.message}');
      handleDioException(e);
    }
  }

  //!DELETE
  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('\n🟢 DELETE Request Starting...');
      print('Path: $path');

      var res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      print('🟢 DELETE Request Completed Successfully');
      print('Response Type: ${res.data.runtimeType}');

      return res.data;
    } on DioException catch (e) {
      print('🔴 DELETE Request Failed');
      print('Error: ${e.message}');
      handleDioException(e);
    }
  }

  //!PUT
  @override
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      print('\n🟢 PUT Request Starting...');
      print('Path: $path');

      var res = await dio.put(
        path,
        data: isFormData && data is! FormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );

      print('🟢 PUT Request Completed Successfully');
      print('Response Type: ${res.data.runtimeType}');

      return res.data;
    } on DioException catch (e) {
      print('🔴 PUT Request Failed');
      print('Error: ${e.message}');
      handleDioException(e);
    }
  }

  //!PATCH
  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      print('\n🟢 PATCH Request Starting...');
      print('Path: $path');

      var res = await dio.patch(
        path,
        data: isFormData && data is! FormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );

      print('🟢 PATCH Request Completed Successfully');
      print('Response Type: ${res.data.runtimeType}');

      return res.data;
    } on DioException catch (e) {
      print('🔴 PATCH Request Failed');
      print('Error: ${e.message}');
      handleDioException(e);
    }
  }
}
