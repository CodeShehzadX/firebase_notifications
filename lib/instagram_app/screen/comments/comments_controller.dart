import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../../services/dummy_data_service.dart';
import '../home/home_controller.dart';

class CommentsController extends GetxController {
  final PostModel post;
  CommentsController(this.post);

  final DummyDataService _data = Get.find<DummyDataService>();
  final TextEditingController input = TextEditingController();

  late final RxList<CommentModel> comments;

  @override
  void onInit() {
    super.onInit();
    comments = RxList<CommentModel>.from(post.commentList);
  }

  void addComment() {
    final text = input.text.trim();
    if (text.isEmpty) return;
    final comment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      user: _data.currentUser,
      text: text,
      timeAgo: 'now',
    );
    comments.insert(0, comment);
    post.commentList.insert(0, comment);
    post.comments += 1;
    input.clear();
    // Keep the feed's "View all comments" count in sync.
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().posts.refresh();
    }
  }

  void toggleLike(CommentModel comment) {
    comment.isLiked = !comment.isLiked;
    comment.likes += comment.isLiked ? 1 : -1;
    comments.refresh();
  }

  @override
  void onClose() {
    input.dispose();
    super.onClose();
  }
}
