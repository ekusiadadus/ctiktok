import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctiktok/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:ctiktok/models/video.dart' as model;

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToFirebaseStorage(
      String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _getVideoThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(
      videoPath,
    );
    return thumbnail;
  }

  Future<String> _uploadThumbnailToFirebaseStorage(
      String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getVideoThumbnail(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await fireStore.collection('users').doc(uid).get();
      var allDocs = await fireStore.collection('videos').get();
      int docCount = allDocs.docs.length;
      String videoUrl =
          await _uploadVideoToFirebaseStorage("Video $docCount", videoPath);
      String thumbnailUrl = await _uploadThumbnailToFirebaseStorage(
          "Thumbnail $docCount", videoPath);
      model.Video video = model.Video(
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        profilePicUrl:
            (userDoc.data()! as Map<String, dynamic>)['profilePicUrl'],
        uid: uid,
        likes: [],
        comments: [],
        shareCount: 0,
        timestamp: DateTime.now(),
        id: "Video $docCount",
      );
      await fireStore
          .collection('videos')
          .doc("Video $docCount")
          .set(video.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar('Error uploading videos', e.toString());
    }
  }
}
