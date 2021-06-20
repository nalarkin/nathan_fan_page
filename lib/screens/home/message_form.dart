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
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Create a message.',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              // expands: true,
              // minLines: 1,
              // maxLines: 10,
              decoration: textInputDecoration,
              validator: (val) {
                return (val?.length as int) < 6
                    ? 'Message must be at least 6 characters.'
                    : null;
              },
              onChanged: (val) => setState(() {
                _content = val;
                _author = 'dummyAuthor';
                _date = DateTime.now();
              }),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  print("content is $_content");
                  print("author is $_author");
                  print("date is ${_date.toString()}");
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ));
  }
}
