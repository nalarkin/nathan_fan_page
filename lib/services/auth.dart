import 'package:fanpage/models/user.dart';
import 'package:fanpage/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fanpage/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  // Stream<TheUser?> get user {
  //   return _auth.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //       print('User is currently signed out!');
  //       print('User is currently signed out!');
  //       print('User is currently signed out!');
  //       print('User is currently signed out!');
  //       print('User is currently signed out!');
  //       print('User is currently signed out!');
  //     } else {
  //       // return _userFromFirebase(user);
  //     }
  //   });
  // }

  TheUser? _userFromFirebase(User? user) {
    print("Pulling user: ${user} from FirebaseAuth");
    return user != null
        ? TheUser(
            uid: user.uid,
            registrationDate: user.metadata.creationTime,
          )
        : null;
  }

  // auth change user stream
  Stream<TheUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
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

  // // sign in with email and password
  // Future signInWithEmailAndPassword(String email, String password) async {
  //   print(
  //       'calling signInWithEmailAndPassword. email: $email password $password');
  //   try {
  //     UserCredential result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);

  //     User? currUser = result.user;
  //     TheUser? curr = _userFromFirebase(currUser);

  //     FirebaseAuth.instance.currentUser;
  //     print('User? currUser = $currUser');
  //     String userRole = await findUserRole(curr);

  //     print('userRole in auth.dart is ${userRole}');
  //     print('User? currUser = $currUser');
  //     if (userRole == 'admin') {
  //       curr?.userRole = 'admin';
  //     }
  //     return curr;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    print(
        'calling signInWithEmailAndPassword. email: $email password $password');
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? currUser = result.user;
      return _userFromFirebase(currUser);
    } catch (e) {
      print(e);
    }
  }

  Future<String> findUserRole(TheUser? user) async {
    String uID = user?.uid ?? '';
    if (uID != null) {
      // DocumentSnapshot? result = await
      userCollection.doc(uID).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document data: ${documentSnapshot.data()}');
          dynamic role = documentSnapshot.get('userRole');
          print("userRole = $role");
          print('================================');
          print('before TheUser change $user');
          user?.userRole = role;
          print('user role after change $user');
          print('================================');
          bool res = (role == 'admin');

          if (role == 'admin') {
            print('USER IS ADMIN!!!!!');
            return 'admin';
          } else {
            return 'Customer';
          }

          // return (role == 'admin');
          // return true;
        } else {
          print('Document does not exist.');
        }
      });
    }
    return 'Customer';
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
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
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
