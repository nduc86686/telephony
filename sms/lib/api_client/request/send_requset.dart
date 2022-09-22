import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms/models/Sms.dart';

import '../../common/network/client.dart';
import '../../models/request/sms_request.dart';


class SendRequest {
  SendRequest();
  Future<void> sendSms({required SmsRequest smsRequest}) async {
    try{
     final response= await Client.getClient()
          .sendSms(SmsRequest(message: '${smsRequest.message}'));
     SmsResponse sms=SmsResponse.fromJson(response.response.data["data"]);
     if(sms.error!=null){
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
