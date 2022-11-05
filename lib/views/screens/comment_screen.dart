import 'package:ctiktok/constants.dart';
import 'package:ctiktok/controllers/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatelessWidget {
  final String id;

  CommentScreen({Key? key, required this.id}) : super(key: key);

  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentController.comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            comment.profilePic,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              "${comment.username}  ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              comment.comment,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              timeago.format(
                                comment.datePublished.toDate(),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${comment.likes.length} like',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () => commentController.likeComment(
                            comment.id,
                          ),
                          icon: Icon(
                            Icons.favorite,
                            color: comment.likes.contains(
                              authController.user.uid,
                            )
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'profile image',
                  ),
                ),
                title: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () =>
                      commentController.postComment(_commentController.text),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
