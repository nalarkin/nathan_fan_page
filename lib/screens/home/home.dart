import 'package:fanpage/models/brew.dart';
import 'package:fanpage/screens/home/settings_form.dart';
import 'package:fanpage/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fanpage/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/screens/home/brew_list.dart';

class Home extends StatelessWidget {
  // const Home({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();
  // final initial = DatabaseService(uid: 'null');
  final List<Brew> initial = [Brew()];

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      initialData: initial,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Nathan's Fans"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('logout')),
            TextButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.settings),
                label: Text('settings')),
          ],
        ),
        body: BrewList(),
      ),
    );
  }
}
