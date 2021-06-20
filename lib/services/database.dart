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
  // final QuerySnapshot<

  // Future updateUserData(String sugars, String name, int strength) async {
  //   return await brewCollection.doc(uid).set({
  //     'sugar': sugars,
  //     'name': name,
  //     'strength': strength,
  //   });
  // }

  Future setUserData(String firstName, String lastName, String userRole) async {
    return await userCollection.doc(uid).set(
        {'firstName': firstName, 'lastName': lastName, 'userRole': userRole});
  }

  // return await userCollection.doc(uid).set({
  //   'firstName': firstName,
  //   'lastName': lastName,
  //   'userRole': userRole,
  // });

  // create UID and add message to database
  Future createMessageData(String content, DateTime? date) async {
    return await messageCollection.add({
      'content': content,
      'date': date,
    });
  }

  // brew list from snapshot
  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        // Future<QuerySnapshot<Object?>> _allDocs = brewCollection.get();
        // _allDocs.then((QueryDocumentSnapshot) =>
        //     QueryDocumentSnapshot.docs.forEach((doc) {
        //       print(doc.id + " " + doc.data().toString());
        //     }));

        return Message(content: doc.get('content'), date: doc.get('date'));
      } catch (e) {
        print(e);
        return Message(content: 'null_content', date: DateTime.now());
      }
    }).toList();
  }

  // get brews stream
  Stream<List<Message>> get messages {
    return messageCollection.snapshots().map(_messageListFromSnapshot);
  }

  // // brew list from snapshot
  // List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     try {
  //       // Future<QuerySnapshot<Object?>> _allDocs = brewCollection.get();
  //       // _allDocs.then((QueryDocumentSnapshot) =>
  //       //     QueryDocumentSnapshot.docs.forEach((doc) {
  //       //       print(doc.id + " " + doc.data().toString());
  //       //     }));

  //       return Brew(
  //           name: doc.get('name'),
  //           sugars: doc.get('sugar'),
  //           strength: doc.get('strength'));
  //     } catch (e) {
  //       print(e);
  //       return Brew(name: 'nullname', sugars: 'nullsugars', strength: 0);
  //     }
  //   }).toList();
  // }

  // // get brews stream
  // Stream<List<Brew>> get brews {
  //   return brewCollection.snapshots().map(_brewListFromSnapshot);
  // }
}
