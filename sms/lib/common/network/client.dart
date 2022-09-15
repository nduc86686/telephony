import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sms/common/network/service.dart';

class Client {
  static String _BASE_URL = 'https://shopee.vn';

  static const int _CONNECT_TIMEOUT = 5000;
  static const int _RECEIVE_TIMEOUT = 5000;
  static const String _CONTENT_TYPE = 'application/json';
  static Dio? _dio;
  static Service? _service;

  static Service getClient() {
    return _service = Service(_configDio());
  }

  static Dio _configDio() {
    _dio = Dio(BaseOptions(
        baseUrl: _BASE_URL,
        connectTimeout: _CONNECT_TIMEOUT,
        receiveTimeout: _RECEIVE_TIMEOUT,
        contentType: _CONTENT_TYPE))
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    return _dio!;
  }

  void setUrl(String? url) {
    if (url != null) {
      _BASE_URL = url;
    }
  }
}
