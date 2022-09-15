import '../../common/network/client.dart';
import '../../models/request/sms_request.dart';


class SendRequest {
  SendRequest();
  Future<void> sendSms({required SmsRequest smsRequest}) async {
    try{
      await Client.getClient()
          .sendSms(SmsRequest(message: '${smsRequest.message}'));
    }catch(e){
      print(e);
    }
  }
}
