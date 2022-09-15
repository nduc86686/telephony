import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';

import 'component/custom_text_input.dart';

///Listen background
onBackgroundMessage(SmsMessage message) async {
  debugPrint("onBackgroundMessage called");
  Vibration.vibrate(duration: 2000);
}

class SmsWidget extends StatefulWidget {
  const SmsWidget({Key? key}) : super(key: key);

  @override
  State<SmsWidget> createState() => _SmsWidgetState();
}

class _SmsWidgetState extends State<SmsWidget> {
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _bodyController = TextEditingController();

  final telephony = Telephony.instance;

  String _message = "";

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
    setState(() {
      _message = message.body ?? "Error reading message body.";
      _bodyController.text = _message;
      _addressController.text =
          message.address ?? 'Error reading message address.';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextInput(
                textEditController: _addressController,
                hintTextString: 'Address',
                inputType: InputType.Default,
                enableBorder: true,
                themeColor: Theme.of(context).primaryColor,
                cornerRadius: 48.0,
                prefixIcon:
                    Icon(Icons.person, color: Theme.of(context).primaryColor),
                textColor: Colors.black,
                labelText: 'Address',
                readOnly: true,
                maxLines: 1,
              ),
              CustomTextInput(
                textEditController: _bodyController,
                hintTextString: 'Enter Body',
                inputType: InputType.Default,
                enableBorder: true,
                cornerRadius: 48.0,
                readOnly: true,
                maxLines: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(16),
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 188, 51),
                  borderRadius: BorderRadius.circular(36),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
