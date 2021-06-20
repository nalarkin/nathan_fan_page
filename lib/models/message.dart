import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final Timestamp date;
  final String content;

  Message({required this.date, this.content = ''});
}
