import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import 'confirm_screen.dart';

class UploadVideoScreen extends StatelessWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  pickVideo(ImageSource src, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: src);
    if (pickedFile != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ConfirmScreen(),
      ));
    }
  }

  takeVideo(BuildContext context) {
    pickVideo(ImageSource.camera, context);
  }

  showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: const Text(
            'Upload Video',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                title: const Text(
                  'Take a video',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  takeVideo(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.video_library,
                  color: Colors.white,
                ),
                title: const Text(
                  'Choose from gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  pickVideo(ImageSource.gallery, context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                title: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: () => showOptionsDialog(context),
        child: Container(
          height: 50,
          width: 190,
          decoration: BoxDecoration(
            color: buttonColor,
          ),
          child: const Center(
            child: Text(
              'Upload Video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      )),
    );
  }
}
