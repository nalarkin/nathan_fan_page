import 'package:fanpage/models/user.dart';
import 'package:fanpage/screens/home/settings_form.dart';
import 'package:fanpage/services/auth.dart';
import 'package:fanpage/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:fanpage/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/screens/home/message_list.dart';
import 'package:fanpage/models/message.dart';

class Home extends StatefulWidget {
  final TheUser? initialUser;
  Home({required this.initialUser});

  @override
  _HomeState createState() => _HomeState(initialUser: initialUser);
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  final userDatabase = DatabaseService(uid: 'null');

  final List<Message> initial = [Message(date: Timestamp.now())];
  TheUser? initialUser;
  _HomeState({this.initialUser});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    // userDatabase.isAdmin(user);

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

    void _confirmationExit() {
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("Logout"),
        onPressed: () async {
          Navigator.of(context).pop();
          await _auth.signOut();
        },
      );

      AlertDialog alert = AlertDialog(
        content: Text("Are you sure you want to logout?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return StreamProvider<List<Message>>.value(
      value: DatabaseService().messages,
      initialData: initial,
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          title: Text("Nathan's Fans"),
          backgroundColor: Colors.blue[900],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  _confirmationExit();
                  // await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('logout')),
            TextButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.settings),
                label: Text('settings')),
          ],
        ),
        body: Center(
          child: Messages(),
        ),
        floatingActionButton: user?.uid != 'l8fO4b6jVQa7p4qD3hFARHxTKtB2'
            ? Container()
            : FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
              ),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final _formKey = GlobalKey<FormState>();
  String messageContent = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a message"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  decoration: textInputDecoration.copyWith(
                      hintText: "Enter message here."),
                  // The validator receives the text that the user has entered.
                  validator: (val) {
                    return (val?.length ?? 0) < 6
                        ? 'Messages must be at least 6 characters.'
                        : null;
                    // return null;
                  },
                  onChanged: (val) {
                    messageContent = val;
                    print(messageContent);
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  DatabaseService()
                      .createMessageData(messageContent, DateTime.now());
                  // print('_isAdmin = $_isAdmin');
                  Navigator.pop(context);
                }
              },
              child: Text('POST MESSAGE'),
            ),
          ],
        ),
      ),
    );
  }
}
