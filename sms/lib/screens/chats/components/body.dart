
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:telephony/telephony.dart';

import '../../../models/Chat.dart';
import '../../../models/data_model.dart';
import '../../list_user/list_user.dart';
import 'chat_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.messages}) : super(key: key);
  final List<SmsMessage> messages;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Box<DataModel> ? dataBox;
  @override
  void initState() {
    dataBox = Hive.box<DataModel>(dataBoxName);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.messages.length,
            itemBuilder: (context, index) => ChatCard(
              chat: Chat(
                address: "${widget.messages[index].address}",
                body: "${widget.messages[index].body}",
                date: "${widget.messages[index].date}",
              ),
              press: () {
                _addUser(name: widget.messages[index].address,phone: widget.messages[index].serviceCenterAddress);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) =>  SmsWidget(address: '${messages[index].address}',body: '${messages[index].body}',)),
                // );
              },
            ),
          ),
        ),
      ],
    );
  }
  Future<void> _addUser({String ? name,String ? phone}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title:  const Text('Bạn có muốn thêm vào danh sách người nhân'),
          actions: <Widget>[
            TextButton(
              child:  const Text('Thêm'),
              onPressed: () {
                DataModel data = DataModel(name: name,phone:phone);
                dataBox?.add(data);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hủy',style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
