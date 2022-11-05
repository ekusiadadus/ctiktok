import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctiktok/constants.dart';
import 'package:get/get.dart';

import '../models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videos = Rx<List<Video>>([]);

  List<Video> get videos => _videos.value;

  @override
  void onInit() {
    super.onInit();
    _videos.bindStream(
      fireStore.collection('videos').snapshots().map(
        (QuerySnapshot query) {
          List<Video> retVal = [];
          query.docs.forEach(
            (element) {
              retVal.add(Video.fromSnapshot(element));
            },
          );
          return retVal;
        },
      ),
    );
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await fireStore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await fireStore.collection('videos').doc(id).update(
        {
          'likes': FieldValue.arrayRemove([uid])
        },
      );
    } else {
      await fireStore.collection('videos').doc(id).update(
        {
          'likes': FieldValue.arrayUnion([uid])
        },
      );
    }
  }
}
