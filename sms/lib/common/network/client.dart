import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sms/common/network/service.dart';

import '../shared_pref.dart';

class Client {
  static String BASE_URL = 'http://192.168.3.10:32308';

  static const int _CONNECT_TIMEOUT = 5000;
  static const int _RECEIVE_TIMEOUT = 5000;
  static const String _CONTENT_TYPE = 'application/json';
  ///application/x-www-form-urlencoded"
  static Dio? _dio;
  static Service? _service;

  static Service getClient() {
    return _service = Service(configDio());
  }

  static Dio configDio() {
    _dio = Dio(BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: _CONNECT_TIMEOUT,
        receiveTimeout: _RECEIVE_TIMEOUT,
        contentType: _CONTENT_TYPE))
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
      ));
    return _dio!;
  }

  static void setUrl(String? url) {
    if (url != null) {
      BASE_URL = url;
    }
  }
}
