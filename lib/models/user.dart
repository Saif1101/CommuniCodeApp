import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

class User{
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final List  languages;

  User({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.languages
});

  factory User.fromDocument(DocumentSnapshot doc){

    return User(
      id: doc.data()['id'],
      email: doc.data()['email'],
      username: doc.data()['username'],
      photoUrl: doc.data()['photoUrl'],
      displayName: doc.data()['displayName'],
      bio: doc.data()['bio'],
      languages: doc.data()['languages']
    );
  }



}