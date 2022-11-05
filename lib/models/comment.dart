import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String username;
  String comment;
  final datePublished;
  List likes;
  String profilePic;
  String uid;
  String id;

  Comment({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePic,
    required this.uid,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'comment': comment,
        'datePublished': datePublished,
        'likes': likes,
        'profilePic': profilePic,
        'uid': uid,
        'id': id,
      };

  static Comment fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Comment(
      username: data['username'],
      comment: data['comment'],
      datePublished: data['datePublished'],
      likes: data['likes'],
      profilePic: data['profilePic'],
      uid: data['uid'],
      id: data['id'],
    );
  }
}
