import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/user.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _users = Rx<List<User>>([]);

  List<User> get users => _users.value;

  searchUser(String query) async {
    _users.bindStream(
      fireStore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<User> retVal = [];
          for (var element in query.docs) {
            retVal.add(User.fromSnapshot(element));
          }
          return retVal;
        },
      ),
    );
  }
}
