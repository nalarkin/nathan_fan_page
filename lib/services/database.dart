import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/models/brew.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');
  // final QuerySnapshot<

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugar': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        // Future<QuerySnapshot<Object?>> _allDocs = brewCollection.get();
        // _allDocs.then((QueryDocumentSnapshot) =>
        //     QueryDocumentSnapshot.docs.forEach((doc) {
        //       print(doc.id + " " + doc.data().toString());
        //     }));

        return Brew(
            name: doc.get('name'),
            sugars: doc.get('sugar'),
            strength: doc.get('strength'));
      } catch (e) {
        print(e);
        return Brew(name: 'nullname', sugars: 'nullsugars', strength: 0);
      }
    }).toList();
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }
}
