import 'dart:io';

import 'package:ctiktok/constants.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ctiktok/models/user.dart' as model;
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<File?> _pickImage;

  File? get profilePic => _pickImage.value;

  pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    _pickImage = Rx<File?>(File(pickedImage!.path));
  }

  // puload to firebase storage
  Future<String> _uploadImageToStorage(File image) async {
    var imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    var snapshot = await firebaseStorage
        .ref()
        .child('profilePics/$imageFileName')
        .putFile(image);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void signUp(
    String username,
    String email,
    String password,
    File? image,
  ) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (image != null) {
          var downloadUrl = await _uploadImageToStorage(image);
          model.User user = model.User(
            name: username,
            email: email,
            profilePic: downloadUrl,
            uid: cred.user!.uid,
          );
          await fireStore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());
        } else {
          model.User user = model.User(
            name: username,
            email: email,
            profilePic: '',
            uid: cred.user!.uid,
          );
          await fireStore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());
        }
      } else {
        Get.snackbar('Error', 'Please fill all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Creating an Account', e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        Get.snackbar('Error', 'Please fill all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Logging In', e.toString());
    }
  }
}
