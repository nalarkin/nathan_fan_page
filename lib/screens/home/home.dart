import 'package:fanpage/screens/home/message_form.dart';
import 'package:fanpage/screens/home/settings_form.dart';
import 'package:fanpage/services/auth.dart';
import 'package:fanpage/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fanpage/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/screens/home/message_list.dart';
import 'package:fanpage/models/message.dart';

// Various ways to solve common  use cases
// https://flutter.dev/docs/cookbook

// Possible way to retrieve textfield input 
// https://flutter.dev/docs/cookbook/forms/retrieve-input


// Way to route admin to create a message
// https://flutter.dev/docs/cookbook/animation/page-route-animation#1-set-up-a-pageroutebuilder

// way to

class Home extends StatelessWidget {
  // const Home({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();
  // final initial = DatabaseService(uid: 'null');
  final List<Message> initial = [Message()];

  @override
  Widget build(BuildContext context) {
    void _createMessage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              // height: 800.0,
              child: MessageForm(),
              // alignment: Alignment.center,
            );
          });
    }

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

    return StreamProvider<List<Message>>.value(
      value: DatabaseService().messages,
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
          // body: MessageList(),
          // body: const MyStatelessWidget(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
          )
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     // _createMessage();
          //   },
          //   child: Icon(Icons.add),
          // ),
          ),
    );
  }
}

// bottomSheet widget
// class MyStatelessWidget extends StatelessWidget {
//   const MyStatelessWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           Scaffold.of(context).showBottomSheet<void>(
//             (BuildContext context) {
//               return Container(
//                 height: 600.0,
//                 color: Colors.amber,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       const Text('BottomSheet'),
//                       ElevatedButton(
//                           child: const Text('Close BottomSheet'),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           })
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatefulWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);
  @override
  _MyStatelessWidgetState createState() => _MyStatelessWidgetState();
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: Expanded(
            child: TextField(),
          ),
          // content: const Text('AlertDialog description'),
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

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
          child: Text('Go!'),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a message.'),
      ),
      body: Center(
        child: Text('Page 2'),
      ),
    );
  }
}
