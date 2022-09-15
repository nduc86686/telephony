import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/Sms.dart';
import '../../models/request/sms_request.dart';

part 'service.g.dart';

@RestApi()
abstract class Service {
  factory Service(Dio dio) = _Service;

  @POST('/api/otp/parseSms')
  Future<HttpResponse<SmsResponse>> sendSms(@Body() SmsRequest smsRequest);
}
