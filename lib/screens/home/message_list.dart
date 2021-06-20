import 'package:fanpage/screens/home/message_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:fanpage/models/message.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    // final brews = Provider.of<QuerySnapshot>(context);
    final messages = Provider.of<List<Message>>(context);
    messages.forEach((message) {
      print(message.content);
      print(message.date);
    });

    // print(brews?.email);
    // print(brews?.uid);

    return ListView.builder(
      itemBuilder: (context, index) {
        return MessageTile(message: messages[index]);
      },
      itemCount: messages.length,
    );
  }
}
