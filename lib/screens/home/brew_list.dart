import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class BrewList extends StatefulWidget {
  const BrewList({Key? key}) : super(key: key);

  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    // final brews = Provider.of<QuerySnapshot>(context);
    final brews = Provider.of<User?>(context);

    // print(brews?.email);
    // print(brews?.uid);
    for (var docs in brews?.providerData as List) {
      print(docs.toString());
      print('line2 in for loop');
    }
    return Container();
  }
}
