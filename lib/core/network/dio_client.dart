import 'package:dio/dio.dart';
import '../../env/env.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.rawg.io/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.queryParameters['key'] = Env.apiKey;
      return handler.next(options);
    },
  ));
}