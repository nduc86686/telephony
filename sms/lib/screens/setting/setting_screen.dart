import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart_app/restart_app.dart';

import '../../common/network/client.dart';
import '../../common/network/service.dart';
import '../../common/shared_pref.dart';
import '../chats/widget/custom_text_input.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _baseUrlController = TextEditingController();

  final TextEditingController _nameUrlController = TextEditingController();
  @override
  void initState() {
    getSharedPref();
    super.initState();
  }
  getSharedPref()async{
    String baseUrl=await SharedPref.getString('BASE_URL')??Client.BASE_URL;
    String nameUrl=await SharedPref.getString('NAME_URL')??'/api/otp/parseSms';
    setState(() {
      _baseUrlController.text=baseUrl;
      _nameUrlController.text=nameUrl;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextInput(
                textEditController: _baseUrlController,
                hintTextString: '${Client.BASE_URL}',
                inputType: InputType.Default,
                enableBorder: true,
                themeColor: Theme.of(context).primaryColor,
                cornerRadius: 48.0,
                prefixIcon:
                    Icon(Icons.wifi_tethering_outlined, color: Theme.of(context).primaryColor),
                textColor: Colors.black,
                labelText: 'BASE_URL',
              ),
              CustomTextInput(
                textEditController: _nameUrlController,
                hintTextString: 'NameUrl.name_url',
                inputType: InputType.Default,
                enableBorder: true,
                cornerRadius: 48.0,
                labelText: 'NAME_URL',
                prefixIcon:
                Icon(Icons.wifi_tethering_outlined, color: Theme.of(context).primaryColor),
                textColor: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  SharedPref.putString('BASE_URL', _baseUrlController.text.trim());
                  SharedPref.putString('NAME_URL', _nameUrlController.text.trim());
                  Fluttertoast.showToast(
                      msg: "Lưu thành công",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  Fluttertoast.showToast(
                      msg: "Đang khởi động lại App",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  Future.delayed(const Duration(seconds: 5),(){
                    Restart.restartApp();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 253, 188, 51),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
