import 'package:fanpage/services/auth.dart';
import 'package:fanpage/shared/constants.dart';
import 'package:fanpage/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';

class SignIn extends StatefulWidget {
  // const SignIn({Key? key}) : super(key: key);
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = new GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              elevation: 0.0,
              title: Text("Sign in to Nate's Fans"),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Register"))
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) {
                          return (val?.isEmpty as bool)
                              ? 'Enter an email'
                              : null;
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) {
                          return (val?.length as int) < 6
                              ? 'Enter password 6+ chars long'
                              : null;
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.pink[400]),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() as bool) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              // _auth.sign

                              if (result == null) {
                                setState(() {
                                  error = 'Incorrect login and/or password.';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(height: 20.0),
                      GoogleAuthButton(
                        onPressed: () async {
                          setState(() => loading = true);
                          dynamic result = await _auth.signInWithGoogle();
                          if (result == null) {
                            print('Error. Gooogle sign in resulted in null.');
                            setState(() => loading = false);
                          } else {
                            print('Google sign in returned: $result');
                          }
                        },
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                )));
  }
}
