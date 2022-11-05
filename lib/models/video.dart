import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String songName;
  String caption;
  String videoUrl;
  String thumbnailUrl;
  String username;
  String profilePicUrl;
  String uid;
  List likes;
  int commentCount;
  int shareCount;
  String id;
  DateTime timestamp;

  Video({
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.username,
    required this.profilePicUrl,
    required this.uid,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.id,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'songName': songName,
        'caption': caption,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'username': username,
        'profilePicUrl': profilePicUrl,
        'uid': uid,
        'likes': likes,
        'commentCount': commentCount,
        'shareCount': shareCount,
        'timestamp': timestamp,
        'id': id,
      };

  static Video fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Video(
      songName: data['songName'],
      caption: data['caption'],
      videoUrl: data['videoUrl'],
      thumbnailUrl: data['thumbnailUrl'],
      username: data['username'],
      profilePicUrl: data['profilePicUrl'],
      uid: data['uid'],
      likes: data['likes'],
      commentCount: data['commentCount'],
      shareCount: data['shareCount'],
      timestamp: data['timestamp'].toDate(),
      id: data['id'],
    );
  }
}
