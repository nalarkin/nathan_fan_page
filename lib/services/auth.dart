import 'package:fanpage/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TheUser? _userFromFirebase(User? user) {
    return user != null ? TheUser(uid: user.uid) : null;
    // return TheUser(uid: user.uid);
  }

  // auth change user stream
  Stream<TheUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
    // .map((User? user) => _userFromFirebase(user))
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? currUser = result.user;
      return _userFromFirebase(currUser);
      // return _userFromFirebase(currUser);
      // FirebaseUser user = result.user;
      // return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? currUser = result.user;
      return _userFromFirebase(currUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? currUser = result.user;
      return _userFromFirebase(currUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
