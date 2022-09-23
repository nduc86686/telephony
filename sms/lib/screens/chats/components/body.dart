
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

import '../../../models/Chat.dart';
import 'chat_card.dart';

class Body extends StatelessWidget {
  const Body({Key? key, required this.messages}) : super(key: key);
  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) => ChatCard(
              chat: Chat(
                address: "${messages[index].address}",
                body: "${messages[index].body}",
                date: "${messages[index].date}",
              ),
              press: () {
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
}
