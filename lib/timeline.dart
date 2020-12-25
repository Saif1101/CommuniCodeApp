import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState(){
    getUsers();
    super.initState();
  }

  getUsers(){
    usersRef.get().then((QuerySnapshot snapshot){
      snapshot.docs.forEach((DocumentSnapshot doc){
        print(doc.data()); //PRINTING THE CONTENTS OF EACH DOCUMENT(as an array)
      }
      );
    });
  }

  Widget build(BuildContext context) {
    return Container();
  }
}
