import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String bio;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;

  User({this.id, this.bio, this.username, this.email, this.photoUrl, this.displayName});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      displayName: doc['displayName'],
      bio: doc['bio'],
      photoUrl: doc['photoUrl'],
    );
  }
}
