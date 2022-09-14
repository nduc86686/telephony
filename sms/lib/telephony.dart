import 'package:flutter/material.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';

onBackgroundMessage(SmsMessage message) async {
  print('messss $message');
  debugPrint("onBackgroundMessage called");
  Vibration.vibrate(duration: 500);
}

class Telephone extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Telephone> {
  String _message = "";
  final telephony = Telephony.instance;

  @override
  void initState() {
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Handle message
        },
        onBackgroundMessage:onBackgroundMessage,
      listenInBackground: true,
    );
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }
  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage,);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Latest received SMS: $_message")),
              // TextButton(
              //     onPressed: () async {
              //       await telephony.openDialer("123413453");
              //     },
              //     child: Text('Open Dialer'))
            ],
          ),
        ));
  }
}