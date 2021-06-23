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
  String firstName = '';
  String lastName = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
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
                      SizedBox(height: 15.0),
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
                      SizedBox(height: 15.0),
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
                      SizedBox(height: 15.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'First Name'),
                        validator: (val) {
                          return (val?.length ?? 0) < 1
                              ? 'First Name Required.'
                              : null;
                        },
                        onChanged: (val) {
                          setState(() {
                            firstName = val;
                          });
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Last Name'),
                        validator: (val) {
                          return (val?.length ?? 0) < 1
                              ? 'Last Name Required.'
                              : null;
                        },
                        onChanged: (val) {
                          setState(() {
                            lastName = val;
                          });
                        },
                      ),
                      SizedBox(height: 15.0),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.pink[400]),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() as bool) {
                              setState(() => loading = true);

                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, firstName, lastName);

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
                      SizedBox(height: 5.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 8.0),
                      )
                    ],
                  ),
                )));
  }
}
