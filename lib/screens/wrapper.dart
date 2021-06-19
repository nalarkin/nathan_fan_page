import 'package:fanpage/models/user.dart';
import 'package:fanpage/screens/authenticate/authenticate.dart';
import 'package:fanpage/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    print(user);

    // return either Home or Authenticate wigdget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
