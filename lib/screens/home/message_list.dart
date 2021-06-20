import 'package:fanpage/screens/home/message_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:fanpage/models/message.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy('date', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return new ListTile(
              title: new Text(data['date'].toDate().toString()),
              subtitle: new Text(data['content']),
            );
          }).toList(),
        );
      },
    );
  }
}


// class MessageList extends StatefulWidget {
//   const MessageList({Key? key}) : super(key: key);

//   @override
//   _MessageListState createState() => _MessageListState();
// }

// class _MessageListState extends State<MessageList> {
//   @override
//   Widget build(BuildContext context) {
//     // final brews = Provider.of<QuerySnapshot>(context);
//     final messages = Provider.of<List<Message>>(context);
//     messages.forEach((message) {
//       // print(message.content);
//       // print(message.date);
//     });

//     // print(brews?.email);
//     // print(brews?.uid);

//     return ListView.builder(
//       itemBuilder: (context, index) {
//         return MessageTile(message: messages[index]);
//       },
//       itemCount: messages.length,
//     );
//   }
// }
