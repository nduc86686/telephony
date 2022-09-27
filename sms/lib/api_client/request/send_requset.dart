import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:sms/models/Sms.dart';
import 'package:sms/models/data_response.dart';

import '../../common/constant.dart';
import '../../common/network/client.dart';
import '../../models/request/sms_request.dart';


class SendRequest {
  SendRequest();
  Future<void> sendSms({required SmsRequest smsRequest}) async {
    try {
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(DataResponseAdapter());
      }
      await Hive.openBox<DataResponse>(dataBoxNameResponse);
      Box<DataResponse>? dataBox =
          Hive.box<DataResponse>(dataBoxNameResponse);
      final response = await Client.getClient()
          .sendSms(SmsRequest(message: '${smsRequest.message}'));
      SmsResponse sms = SmsResponse.fromJson(response.response.data["data"]);

      // dataBox.add(data);
      if (sms.error != null) {
        DataResponse data = DataResponse(bank: '',balance:'' ,time:'' ,content: '',error: '${sms.error}');
        dataBox.add(data);
        Fluttertoast.showToast(
            msg: "${sms.error}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        print("save to file");
        DataResponse data = DataResponse(bank: '${sms.bank}',balance:'${sms.balance}' ,time:'${sms.time}' ,content: '${sms.content}',error: '');
        dataBox.add(data);
        Fluttertoast.showToast(
            msg: "Gửi SMS tới Server thành công",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }catch(e){
      print(e);
    }
  }
}
