import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/models/brew.dart';
import 'package:fanpage/models/message.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  // final CollectionReference brewCollection =
  //     FirebaseFirestore.instance.collection('brews');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future setUserData(String firstName, String lastName, String userRole) async {
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'userRole': userRole,
      'registrationDate': DateTime.now()
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
