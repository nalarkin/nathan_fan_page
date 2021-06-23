import 'package:fanpage/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fanpage/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:fanpage/models/user.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _firstName = '';
  String _lastName = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Update your name.',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'First Name'),
              validator: (val) =>
                  (val?.isEmpty ?? false) ? 'Enter a first name.' : null,
              onChanged: (val) => setState(() => _firstName = val),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Last Name'),
              validator: (val) =>
                  (val?.isEmpty ?? false) ? 'Enter a last name.' : null,
              onChanged: (val) => setState(() => _lastName = val),
            ),
            // slider

            ElevatedButton(
                onPressed: () async {
                  await DatabaseService(uid: user?.uid ?? '')
                      .updateUserData(_firstName, _lastName);
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ));
  }
}
