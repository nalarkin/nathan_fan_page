import 'package:fanpage/services/auth.dart';
import 'package:fanpage/shared/constants.dart';
import 'package:fanpage/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
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
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign up to Nates Fans'),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Sign In"))
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
                              ? 'Enter and email'
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
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'register with a valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          )),
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
