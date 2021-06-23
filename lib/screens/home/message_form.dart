import 'package:flutter/material.dart';
import 'package:fanpage/shared/constants.dart';

class MessageForm extends StatefulWidget {
  const MessageForm({Key? key}) : super(key: key);

  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _content = '';
  DateTime? _date = DateTime.now();
  String _author = '';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: textInputDecoration,
        scrollPadding: EdgeInsets.all(20.0),
        autofocus: true,
      ),
    );
  }
}
