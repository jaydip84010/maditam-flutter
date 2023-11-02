import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/config/config.dart';
import 'package:medyo/services/interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final isAppLiveProvider = StateProvider<bool>((ref) {
  return true;
});

final dioProvider = Provider<Dio>((ref) {
  final Dio dio = Dio();

  //Basic Configuration
  dio.options.baseUrl =
      ref.watch(isAppLiveProvider) ? AppConfig.baseUrl : AppConfig.uatbaseUrl;
  dio.options.connectTimeout = 10000;
  dio.options.receiveTimeout = 10000;
  // _dio.options.headers = {'Content-Type': 'application/json'};
  dio.options.headers = {'Accept': 'application/json'};
  dio.options.headers = {'accept': 'application/json'};
  dio.options.followRedirects = false;

  //for Logging the Request And response
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ),
  );

  //Intercepts all requests and adds the token to the header and Allows Global Logout
  dio.interceptors.add(ElTanvirInterceptors());

  return dio;
});
