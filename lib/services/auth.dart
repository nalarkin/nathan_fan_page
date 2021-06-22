import 'package:fanpage/models/user.dart';
import 'package:fanpage/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TheUser? _userFromFirebase(User? user) {
    print("user you want to register is ${user}");
    return user != null
        ? TheUser(uid: user.uid, registrationDate: user.metadata.creationTime)
        : null;
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      print("Signed in with google as {$userCredential}");
      return userCredential;
    } catch (e) {
      print(e);
    }

    // register with email and password
    // Future updateUserInfo(String firstName, String lastName) async {
    //   try {
    //     UserCredential result = await _auth.createUserWithEmailAndPassword(
    //         email: email, password: password);
    //     User? currUser = result.user;
    //     await DatabaseService(uid: currUser?.uid as String)
    //         .setUserData('dummyFirst', 'dummyLast', 'dummyRole');
    //     return _userFromFirebase(currUser);
    //   } catch (e) {
    //     print(e.toString());
    //     return null;
    //   }
    // }

    // register with email and password
    Future registerWithEmailAndPassword(String email, String password,
        String firstName, String lastName) async {
      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User? currUser = result.user;
        await DatabaseService(uid: currUser?.uid as String)
            .setUserData(firstName, lastName, 'Customer');
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
}
