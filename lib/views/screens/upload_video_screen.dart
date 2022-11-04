import 'package:flutter/material.dart';

import '../../constants.dart';

class UploadVideoScreen extends StatelessWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);

  showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title:
              const Text('Upload Video', style: TextStyle(color: Colors.white)),
          content: const Text('Choose an option',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Record', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Upload', style: TextStyle(color: Colors.white)),
            ),
          ],
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
