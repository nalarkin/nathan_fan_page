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
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

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
        } else {
          print('Document does not exist.');
        }
      });
    }
    return 'Customer';
  }

  Future createUserInDatabaseWithGoogle(User user) async {
    List userName = user.displayName?.split(' ') ?? List.empty();
    if (userName.length > 0) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': userName[0],
        'lastName': userName[1],
        'email': user.email,
        'registrationDate': DateTime.now(),
        'userRole': 'Customer',
      });
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
      User? user = userCredential.user;
      if (user != null) {
        print(
            'FirebaseUser creation time: ${user.metadata.creationTime} FirebaseUser lastSignInTime: ${user.metadata.lastSignInTime}');
        // If it is a new user (signing in for the first time), create a user in the database
        DateTime? creation = user.metadata.creationTime;
        DateTime? lastSignIn = user.metadata.lastSignInTime;
        if ((creation?.difference(lastSignIn ?? DateTime.now()).abs() ??
                Duration(seconds: 2)) <
            Duration(seconds: 1)) {
          print('Creating new user in Database.');
          createUserInDatabaseWithGoogle(user);
        }
      }
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
