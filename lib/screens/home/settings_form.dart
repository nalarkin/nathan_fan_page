import 'package:flutter/material.dart';
import 'package:fanpage/shared/constants.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currName = '';
  String _currSugars = '';
  int _currStrength = 100;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Update your brew settings.',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration,
              validator: (val) =>
                  (val?.isEmpty as bool) ? 'Please enter a name' : null,
              onChanged: (val) => setState(() => _currName = val),
            ),
            SizedBox(
              height: 20.0,
            ),
            // dropdown
            DropdownButtonFormField(
              decoration: textInputDecoration,
              value: _currSugars.isEmpty ? '0' : _currSugars,
              onChanged: (val) => setState(() => _currSugars = val as String),
              items: sugars.map((sugar) {
                return DropdownMenuItem(
                  value: sugar,
                  child: Text('$sugar sugars'),
                );
              }).toList(),
            ),
            // slider

            ElevatedButton(
                onPressed: () async {
                  print(_currName);
                  print(_currSugars);
                  print(_currStrength);
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ));
  }
}
