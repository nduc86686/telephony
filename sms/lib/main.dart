import 'package:flutter/material.dart';
import 'package:sms/screens/chats/chats_screen.dart';
import 'package:sms/telephony.dart';
import 'package:sms/theme.dart';
import 'package:telephony/telephony.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SMS VIP',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
      home: ChatsScreen()
    );
  }
}


