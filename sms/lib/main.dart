import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sms/models/data_response.dart';
import 'package:sms/screens/home/home.dart';
import 'package:sms/theme.dart';

import 'common/constant.dart';
import 'models/data_model.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DataModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(DataResponseAdapter());
  }

  Hive.init(appDocumentDirectory.path);
  await Hive.openBox<DataModel>(dataBoxNameTake);
  await Hive.openBox<DataResponse>(dataBoxNameResponse);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SMS Tracking',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        home: const HomeScreen());
  }
}


