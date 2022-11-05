import 'package:ctiktok/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              border: InputBorder.none,
            ),
            onFieldSubmitted: (value) => searchController.searchUser(value),
          ),
        ),
        body: searchController.users.isEmpty
            ? const Center(
                child: Text(
                  'Search Screen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.users.length,
                itemBuilder: (context, index) {
                  User user = searchController.users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
