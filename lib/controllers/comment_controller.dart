import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);

  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostId(String postId) {
    _postId = postId;
    getComment();
  }

  getComment() async {
    _comments.bindStream(
      fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Comment> retVal = [];
          for (var element in query.docs) {
            retVal.add(Comment.fromSnapshot(element));
          }
          return retVal;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await fireStore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await fireStore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();

        var id = allDocs.docs.length.toString();
        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePic: (userDoc.data()! as dynamic)['profilePic'],
          uid: authController.user.uid,
          id: 'Comment $id',
        );
        await fireStore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $id')
            .set(comment.toJson());
        DocumentSnapshot doc =
            await fireStore.collection('videos').doc(_postId).get();
        await fireStore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar('Error sending comments', e.toString());
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update(
        {
          'likes': FieldValue.arrayRemove([uid])
        },
      );
    } else {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update(
        {
          'likes': FieldValue.arrayUnion([uid])
        },
      );
    }
  }
}
