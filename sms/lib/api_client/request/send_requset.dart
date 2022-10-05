

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:sms/models/Sms.dart';
import 'package:sms/models/data_response.dart';

import '../../common/constant.dart';
import '../../common/network/client.dart';
import '../../common/shared_pref.dart';
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
      if (Platform.isAndroid) {
        SharedPreferencesAndroid.registerWith();
      }
      String baseUrl=await SharedPref.getString('BASE_URL')??Client.BASE_URL;
      String nameUrl=await SharedPref.getString('NAME_URL')??'/api/otp/parseSms';
      Client.setUrl(baseUrl);

      final responses = await Client.configDio().post(nameUrl,data:SmsRequest(message: '${smsRequest.message}') );
      SmsResponse sms = SmsResponse.fromJson(responses.data["data"]);

      if (sms.error != null) {
        final f = DateFormat('yyyy-MM-dd hh:mm:ss');
        DataResponse data = DataResponse(bank: '',balance:'' ,time:f.format(DateTime.now()) ,content: '',error: '${sms.error}');
        print("save to file eror");
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
      print('error $e');
    }
  }
}
