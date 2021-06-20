import 'package:flutter/material.dart';
import 'package:fanpage/screens/home/home.dart';

class MessageCreationPage extends StatefulWidget {
  @override
  _MessageCreationPageState createState() => _MessageCreationPageState();
}

class _MessageCreationPageState extends State<MessageCreationPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a message.'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (val) =>
                  (val?.isEmpty as bool) ? 'Please enter a name' : null,
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  print('You clicked submit!!');
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
            Text('Page 2'),
          ],
        ),
      ),
    );
  }
}
