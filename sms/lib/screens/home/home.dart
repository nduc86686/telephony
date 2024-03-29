import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sms/common/extension/contains.dart';
import 'package:sms/screens/chats/chats_screen.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';

import '../../api_client/request/send_requset.dart';
import '../../common/constant.dart';
import '../../common/network/client.dart';
import '../../models/data_model.dart';
import '../../models/request/sms_request.dart';
import '../data_response/data_response_screen.dart';
import '../list_user/list_user.dart';
import '../setting/setting_screen.dart';

// +84980200623
///Listen background
onBackgroundMessage(SmsMessage message) async {
  String? address = message.address?.toLowerCase();
  String? phoneNumber = message.serviceCenterAddress!;

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid){
    PathProviderAndroid.registerWith();
  }
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DataModelAdapter());
  }
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox<DataModel>(dataBoxNameTake);
  Box<DataModel>? dataBox = Hive.box<DataModel>(dataBoxNameTake);
  for (int i = 0; i < dataBox.length; i++) {
    String? addressBox = dataBox.getAt(i)?.name?.toLowerCase();
    String? phone = dataBox.getAt(i)?.phone;
    if (addressBox.containsIgnoreCase(address!) == true ||
        phone == phoneNumber) {
      SendRequest sendRequest = SendRequest();
      sendRequest.sendSms(smsRequest: SmsRequest(message: '${message.body}'));
      Vibration.vibrate(duration: 2000);
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  Box<DataModel>? dataBox;

  final telephony = Telephony.instance;

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage,
          onBackgroundMessage: onBackgroundMessage,
          listenInBackground: true);
    }
    if (!mounted) return;
  }

  onMessage(SmsMessage message) async {
    // String? address = message.address;
    // String? phoneNumber = message.serviceCenterAddress!;
    // dataBox = Hive.box<DataModel>(dataBoxNameTake);
    // for (int i = 0; i < dataBox!.length; i++) {
    //   String? addressBox = dataBox?.getAt(i)?.name?.toLowerCase();
    //   String? phone = dataBox?.getAt(i)?.phone;
    //   if (addressBox.containsIgnoreCase(address!) == true ||
    //       phone == phoneNumber) {
    //     SendRequest sendRequest = SendRequest();
    //     sendRequest.sendSms(smsRequest: SmsRequest(message: '${message.body}'));
    //   }
    // }
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ListUserTakeScreen(),
    DataResponseScreen(),
    ChatsScreen(),

  ];

  @override
  void initState() {
    initialization();
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    dataBox?.close();
    super.dispose();
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Tracking'),
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                );
              },
            )
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.list),
              title: const Text("Danh sách người nhận"),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.wechat_outlined),
              title: const Text("Danh sách đã gửi"),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.sms),
              title: const Text("Tin nhắn"),
              selectedColor: Colors.purple,
            ),


          ],
        ),
      ),
    );
  }

  Future<void> sendSms({required SmsRequest body}) async {
    await Client.getClient().sendSms(body);
  }
}
