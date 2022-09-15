import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'service.g.dart';

@RestApi()
abstract class Service {
  factory Service(Dio dio) = _Service;

  @POST('/api/v2/authentication/login')
  Future<HttpResponse<dynamic>> login(@Body() dynamic acc);
}
