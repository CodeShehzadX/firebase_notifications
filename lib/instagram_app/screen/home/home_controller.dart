import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../services/dummy_data_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/post_menu_sheet.dart';
import '../comments/comments_controller.dart';
import '../comments/comments_sheet.dart';
import '../share/share_controller.dart';
import '../share/share_sheet.dart';

class HomeController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();

  late final RxList<PostModel> posts;
  late final RxList<UserModel> stories;

  /// Ids of users whose story has been viewed this session.
  final RxSet<int> viewedStories = <int>{}.obs;

  UserModel get me => _data.currentUser;

  @override
  void onInit() {
    super.onInit();
    posts = _data.feedPosts.obs;
    stories = _data.suggestions.obs;
  }

  /// Prepends a newly created post to the front of the feed.
  void addPost(PostModel post) => posts.insert(0, post);

  /// Heart-icon tap: toggles like both ways.
  void toggleLike(PostModel post) {
    post.isLiked = !post.isLiked;
    post.likes += post.isLiked ? 1 : -1;
    posts.refresh();
  }

  /// Double-tap: only ever likes, never unlikes.
  void likePost(PostModel post) {
    if (post.isLiked) return;
    post.isLiked = true;
    post.likes += 1;
    posts.refresh();
  }

  void toggleSave(PostModel post) {
    post.isSaved = !post.isSaved;
    posts.refresh();
  }

  void toggleFollow(UserModel user) {
    user.isFollowing = !user.isFollowing;
    user.followers += user.isFollowing ? 1 : -1;
    posts.refresh();
  }

  void toggleRepost(PostModel post) {
    post.isReposted = !post.isReposted;
    if (post.isReposted) {
      _data.myReposts.insert(0, post);
    } else {
      _data.myReposts.removeWhere((p) => p.id == post.id);
    }
    posts.refresh();
  }

  // --- Stories ---------------------------------------------------------------

  bool isStoryViewed(int userId) => viewedStories.contains(userId);

  void markStoryViewed(int userId) => viewedStories.add(userId);

  void openStory(UserModel user) =>
      Get.toNamed(AppRoutes.story, arguments: user);

  // --- Sheets ----------------------------------------------------------------

  void openComments(PostModel post) {
    Get.put(CommentsController(post));
    Get.bottomSheet(
      const CommentsSheet(),
      isScrollControlled: true,
      backgroundColor: AppColors.white,
    ).whenComplete(() => Get.delete<CommentsController>());
  }

  void openShare(PostModel post) {
    Get.put(ShareController(post));
    Get.bottomSheet(
      const ShareSheet(),
      isScrollControlled: true,
      backgroundColor: AppColors.white,
    ).whenComplete(() => Get.delete<ShareController>());
  }

  void openPostMenu(PostModel post) {
    Get.bottomSheet(
      const PostMenuSheet(),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}
