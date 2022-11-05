import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = ''.obs;

  String get uid => _uid.value;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await fireStore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();
    for (var element in myVideos.docs) {
      thumbnails.add((element.data() as dynamic)['thumbnailUrl']);
    }

    DocumentSnapshot userDoc =
        await fireStore.collection('users').doc(_uid.value).get();
    final data = userDoc.data() as Map<String, dynamic>;
    String username = data['name'];
    String profilePic = data['profilePic'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var element in myVideos.docs) {
      likes += (element.data()['likes'] as List).length;
    }
    var followersDoc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    followers = followersDoc.docs.length;
    var followingDoc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    following = followingDoc.docs.length;

    fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'name': username,
      'profilePic': profilePic,
      'likes': likes.toString(),
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (!doc.exists) {
      await fireStore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      await fireStore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await fireStore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await fireStore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
