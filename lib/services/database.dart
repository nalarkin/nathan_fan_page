import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/models/message.dart';
import 'package:fanpage/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService extends ChangeNotifier {
  final String? uid;
  DatabaseService({this.uid});
  bool _isAdmin = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');

  Query qAdmins = FirebaseFirestore.instance
      .collection('users')
      .where("userRole", isEqualTo: "admin");

  Future setUserData(
      String firstName, String lastName, String userRole, String email) async {
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'userRole': userRole,
      'email': email,
      'registrationDate': DateTime.now()
    });
  }

  bool get getAdmin {
    return _isAdmin;
  }

  void isAdmin(TheUser? user) async {
    String uID = user?.uid ?? '1';
    userCollection.doc(uID).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        dynamic role = documentSnapshot.get('userRole');
        if (role == 'admin') {
          print('I CAN SEE ITS ADMIN!!');

          _isAdmin = true;
          notifyListeners();
        } else {
          print('I CAN NOT SEE ITS ADMIN');
        }
      } else {
        print('Document does not exist.');
      }
    });
  }

  Future updateUserData(String firstName, String lastName) async {
    return await userCollection.doc(uid).set(
        {'firstName': firstName, 'lastName': lastName},
        SetOptions(merge: true));
  }

  // create UID and add message to database
  Future createMessageData(String content, DateTime? date) async {
    return await messageCollection.add({
      'content': content,
      'date': date,
    });
  }

  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return Message(content: doc.get('content'), date: doc.get('date'));
      } catch (e) {
        print(e);
        return Message(content: 'null_content', date: Timestamp.now());
      }
    }).toList();
  }

  // get brews stream
  Stream<List<Message>> get messages {
    return messageCollection.snapshots().map(_messageListFromSnapshot);
  }
}
