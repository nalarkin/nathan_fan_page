import 'package:fanpage/models/user.dart';
import 'package:fanpage/screens/home/message_form.dart';
import 'package:fanpage/screens/home/settings_form.dart';
import 'package:fanpage/screens/transitions/page_transition.dart';
import 'package:fanpage/services/auth.dart';
import 'package:fanpage/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fanpage/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/screens/home/message_list.dart';
import 'package:fanpage/models/message.dart';
import 'package:provider/provider.dart';

// Various ways to solve common  use cases
// https://flutter.dev/docs/cookbook

// Possible way to retrieve textfield input
// https://flutter.dev/docs/cookbook/forms/retrieve-input

// Way to route admin to create a message
// https://flutter.dev/docs/cookbook/animation/page-route-animation#1-set-up-a-pageroutebuilder

// way to

class Home extends StatefulWidget {
  // const Home({Key? key}) : super(key: key);
  TheUser? initialUser;
  Home({required this.initialUser});

  @override
  _HomeState createState() => _HomeState(initialUser: initialUser);
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  final userDatabase = DatabaseService(uid: 'null');
  // Future<bool> _isAdmin = Future.value(false);
  bool _isAdmin = true;

  // Future.value(false).then(updateAdmin);

  final List<Message> initial = [Message(date: Timestamp.now())];
  TheUser? initialUser;
  _HomeState({this.initialUser});

  // DatabaseService().isAdmin(initialUser).then

  // Future<bool> updateAdmin() async {
  //   bool isAdmin = await userDatabase.isAdmin(context, initialUser);
  //   print('isAdmin within updateAdmin() $isAdmin');
  //   return isAdmin;
  //   // return await userDatabase.isAdmin(initialUser);
  //   // setState(() {
  //   //   _isAdmin = isAdmin;
  //   // });
  // }

  /* promising idea, isn't working :(. Value returned from updateAdmin is 
    seen as false. But inside the method, it updateAdmin method, it reads a 
    true value. */
  // @override
  // void initState() {
  //   updateAdmin().then((val) {
  //     print('val in initstate() is $val');
  //     setState(() {
  //       print('val in initstate() is $val');
  //       _isAdmin = val;
  //     });
  //   }).onError((error, stackTrace) {
  //     print(error);
  //   });
  //   super.initState();
  // }

  // updateAdmin();
  // @override
  // void initState() {
  //   Future<bool> isAdmin = userDatabase.isAdmin(initialUser);
  //   setState(() {
  //     _isAdmin = isAdmin;
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    bool _isAdmin = userDatabase.getAdmin;
    final user = Provider.of<TheUser?>(context);
    userDatabase.isAdmin(user);
    // Future<bool> _isAdmin = DatabaseService().isAdmin(user?.uid);
    // DatabaseService().findUserRole(user);
    // findUserRole

    print('_isAdmin in build method is = $_isAdmin');
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
        backgroundColor: Colors.blue[100],
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
                onPqressed: () async {
                  print("user: ${user?.uid}");
                  // Future<bool> _new_isAdmin =
                  //     DatabaseService(uid: user?.uid).isAdmin();
                  // dynamic res = await DatabaseService().isAdmin(user?.uid);
                  // print('_isAdmin = $res');
                  // print(__isAdmin);
                  print(user);
                  // bool res = DatabaseService().isAdmin(user?.uid ?? '');
                  // print('qQuery within home.dart $res');
                  // print('_isAdmin = ${_isAdmin.toString()}');
                  // print('------------');
                  // print(user?.userRole);

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
                // Validate returns true if the form is valid, or false otherwise.
                // if (_formKey.currentState!.validate()) {
                // print(_formKey.);
                if (_formKey.currentState?.validate() ?? false) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                  DatabaseService()
                      .createMessageData(messageContent, DateTime.now());
                  // print('_isAdmin = $_isAdmin');
                  Navigator.pop(context);
                }
              },
              child: Text('POST MESSAGE'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: Text('Go back!'),
            // ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationExit extends StatelessWidget {
  const ConfirmationExit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}

Widget _getFAB(TheUser? user) {
  if (user?.userRole != 'admin') {
    return Container();
  } else {
    return FloatingActionButton(
        backgroundColor: Colors.deepOrange[800],
        child: Icon(Icons.add_shopping_cart),
        onPressed: null);
  }
}
