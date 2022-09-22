import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sms/screens/home/home.dart';
import 'package:sms/screens/list_user/list_user.dart';
import 'package:sms/theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'models/data_model.dart';


Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.registerAdapter(DataModelAdapter());
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox<DataModel>(dataBoxName);
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


