import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/post_menu_sheet.dart';
import '../comments/comments_controller.dart';
import '../comments/comments_sheet.dart';
import '../share/share_controller.dart';
import '../share/share_sheet.dart';

/// Shared post interaction logic reused by [HomeController], [ReelsController]
/// and [PostDetailController] so the like / save / repost / comment / share /
/// menu flows are implemented once.
mixin PostActionsMixin on GetxController {
  /// The data service the host controller uses.
  DummyDataService get postData;

  /// Called after a post mutates so the host can refresh its own Rx surface.
  void onPostChanged();

  /// Heart-icon tap: toggles like both ways.
  void toggleLike(PostModel post) {
    post.isLiked = !post.isLiked;
    post.likes += post.isLiked ? 1 : -1;
    onPostChanged();
  }

  /// Double-tap: only ever likes, never unlikes.
  void likePost(PostModel post) {
    if (post.isLiked) return;
    post.isLiked = true;
    post.likes += 1;
    onPostChanged();
  }

  void toggleSave(PostModel post) {
    post.isSaved = !post.isSaved;
    onPostChanged();
  }

  void toggleRepost(PostModel post) {
    post.isReposted = !post.isReposted;
    if (post.isReposted) {
      postData.myReposts.insert(0, post);
    } else {
      postData.myReposts.removeWhere((p) => p.id == post.id);
    }
    onPostChanged();
  }

  void toggleFollow(UserModel user) {
    user.isFollowing = !user.isFollowing;
    user.followers += user.isFollowing ? 1 : -1;
    onPostChanged();
  }

  void openComments(PostModel post) {
    Get.put(CommentsController(post));
    Get.bottomSheet(
      const CommentsSheet(),
      isScrollControlled: true,
      backgroundColor: AppColors.white,
    ).whenComplete(() {
      Get.delete<CommentsController>();
      onPostChanged();
    });
  }

  void openShare(PostModel post) {
    Get.put(ShareController(post: post));
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
