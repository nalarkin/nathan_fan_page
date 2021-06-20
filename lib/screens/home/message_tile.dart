import 'package:flutter/material.dart';
import 'package:fanpage/models/message.dart';

class MessageTile extends StatelessWidget {
  // const BrewTile({Key? key}) : super(key: key);
  final Message message;

  MessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[500],
            ),
            title: Text(message.date as String),
            subtitle: Text('Message Content could go here.'),
          ),
        ));
  }
}
