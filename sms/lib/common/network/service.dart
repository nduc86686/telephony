import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/Sms.dart';
import '../../models/request/sms_request.dart';
import '../shared_pref.dart';

part 'service.g.dart';

@RestApi()
abstract class Service {
  factory Service(Dio dio) = _Service;

  @POST('/api/otp/parseSms')
  Future<HttpResponse<SmsResponse>> sendSms(@Body() SmsRequest smsRequest);
}

class NameUrl {
   String NAME_URL = '/api/otp/parseSms';
   get url=>NAME_URL;
   void setNameUrl(String? url) {
    if (url != null) {
      NAME_URL = url;
    }
  }
}
