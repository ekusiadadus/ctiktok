import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctiktok/controllers/auth_controller.dart';
import 'package:ctiktok/views/screens/search_screen.dart';
import 'package:ctiktok/views/screens/upload_video_screen.dart';
import 'package:ctiktok/views/screens/video_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const UploadVideoScreen(),
  Text('Messages'),
  Text('Profile'),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var fireStore = FirebaseFirestore.instance;

// CONTROLLERS
var authController = AuthController.instance;
