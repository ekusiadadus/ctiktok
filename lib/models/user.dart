import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String email;
  String profilePic;
  String uid;

  User({
    required this.name,
    required this.email,
    required this.profilePic,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'uid': uid,
    };
  }

  static User fromSnapshot(DocumentSnapshot snapshot) {
    return User(
      name: snapshot['name'],
      email: snapshot['email'],
      profilePic: snapshot['profilePic'],
      uid: snapshot['uid'],
    );
  }
}
