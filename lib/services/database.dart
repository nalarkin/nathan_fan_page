import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/models/brew.dart';
import 'package:fanpage/models/message.dart';
import 'package:fanpage/models/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  // final CollectionReference brewCollection =
  //     FirebaseFirestore.instance.collection('brews');
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');

  Query qAdmins = FirebaseFirestore.instance
      .collection('users')
      .where("userRole", isEqualTo: "admin");

  Future setUserData(String firstName, String lastName, String userRole) async {
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'userRole': userRole,
      'registrationDate': DateTime.now()
    });
  }

  String findUserRole(TheUser? user) {
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

  // TheUser? createUser (String uID) {
  //   if (uID != null) {
  //     // DocumentSnapshot? result = await
  //     userCollection.doc(uID).get().then((DocumentSnapshot documentSnapshot) {
  //       if (documentSnapshot.exists) {
  //         print('Document data: ${documentSnapshot.data()}');
  //         TheUser(uid: uID, )
  //         String role = documentSnapshot.get('userRole');
  //         print("userRole = $role");
  //         bool res = (role == 'admin');
  //         print(res);
  //         return res;

  //         // return (role == 'admin');
  //         // return true;
  //       } else {
  //         print('Document does not exist.');
  //       }
  //     });
  //   }
  // }

  bool isAdmin(String uID) {
    print(qAdmins.parameters);
    return true;
  }

  // Future<bool> isAdmin(String? uID) async {
  //   if (uID != null) {
  //     // DocumentSnapshot? result = await
  //     userCollection.doc(uID).get().then((DocumentSnapshot documentSnapshot) {
  //       if (documentSnapshot.exists) {
  //         print('Document data: ${documentSnapshot.data()}');
  //         dynamic role = documentSnapshot.get('userRole');
  //         print("userRole = $role");
  //         bool res = (role == 'admin');
  //         print(res);
  //         return res;

  //         // return (role == 'admin');
  //         // return true;
  //       } else {
  //         print('Document does not exist.');
  //       }
  //     });
  //   }
  //   return false;
  // }

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
