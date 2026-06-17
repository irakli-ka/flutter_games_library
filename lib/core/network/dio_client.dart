import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.rawg.io/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.queryParameters['key'] = 'd37c891ef01046cd82ec619ccbb7d0e7';
      return handler.next(options);
    },
  ));
}