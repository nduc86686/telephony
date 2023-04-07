import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sms/common/network/service.dart';

import '../shared_pref.dart';

class Client {
  static String BASE_URL = 'https://admin.oceandemy.com';
  static String TOKEN = '367a6f16382ef31008c3314a489a76f05eac5a91787f8c05d9db9648794fa7c6928dde98748823023eb9c064c10e0b24834a76918a6138742e4f1b342346e5a06090d0568cd6b1b38af0913116858d5965ff67cb5fc56b3c46e05f5d74df32f0feeccfbd4ff686cf4db4ab1887b1c5049ec5788f9f618e4ff0fa39a37045a6b7';

  static const int _CONNECT_TIMEOUT = 5000;
  static const int _RECEIVE_TIMEOUT = 5000;
  static const String _CONTENT_TYPE = 'application/json';
  ///application/x-www-form-urlencoded"
  static Dio? _dio;
  static Service? _service;

  static Service getClient() {
    return _service = Service(configDio());
  }

  static Dio configDio({String ?token}) {
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
        request: true,
        error: true,
        compact: true,
      ));
    _dio?.options.headers["Authorization"] = "Bearer ${token??TOKEN}}";
    print('token ${_dio?.options.headers["Authorization"]}');
    return _dio!;
  }

  static void setUrl(String? url) {
    if (url != null) {
      BASE_URL = url;
    }
  }

  static void token(String? token) {
    if (token != null) {
      TOKEN = token;
    }
  }
}
