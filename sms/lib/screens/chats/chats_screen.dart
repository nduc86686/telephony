import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';

import '../../constants.dart';
import 'components/body.dart';

///Listen background
onBackgroundMessage(SmsMessage message) async {
  debugPrint("onBackgroundMessage called");
  Vibration.vibrate(duration: 2000);
}

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final telephony = Telephony.instance;
  String _message = "";

  List<SmsMessage> messages = [];
  bool isListenBackground = true;

  late EasyRefreshController _controller;
  int _count = 10;
  @override
  void initState() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    getList();
    super.initState();
    initPlatformState();
  }

  getList() async {
    messages = await Telephony.instance.getInboxSms();
    setState(() {});
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage,
          onBackgroundMessage: isListenBackground ? onBackgroundMessage : null,
          listenInBackground: isListenBackground);
    }
    if (!mounted) return;
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
        controller: _controller,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 4));
          getList();
          if (!mounted) {
            return;
          }
          setState(() {
            _count = 10;
          });
          _controller.finishRefresh();
          _controller.resetFooter();
        },
        header: const ClassicHeader(),
        child: Body(
          messages: messages,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isListenBackground = !isListenBackground;
          });
          initPlatformState();
          SnackBar snackBar = SnackBar(
            content: isListenBackground == true
                ? const Text('BẬT LẮNG NGHE TIN NHẮN Ở CHẾ ĐỘ NỀN')
                : const Text('TẮT LẮNG NGHE TIN NHẮN Ở CHẾ ĐỘ NỀN'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.ads_click,
          color: Colors.white,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Chats"),
    );
  }
}
