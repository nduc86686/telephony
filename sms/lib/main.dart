import 'package:flutter/material.dart';
import 'package:sms/screens/home/home.dart';
import 'package:sms/theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SMS OCEANDEMY',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        home: const HomeScreen());
  }
}


