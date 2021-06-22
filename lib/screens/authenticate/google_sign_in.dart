import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }
}
