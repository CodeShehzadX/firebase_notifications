import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/post_card.dart';
import '../../widgets/svg_icon.dart';
import 'post_detail_controller.dart';

/// Dedicated single-post screen opened from a profile grid.
class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostDetailController controller = Get.find<PostDetailController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 36,
        leading: IconButton(
          onPressed: Get.back,
          icon: const SvgIcon(AppAssets.back, size: 22),
        ),
        titleSpacing: 0,
        title: const Text(
          'Post',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          final post = controller.post.value;
          return PostCard(
            post: post,
            onLike: () => controller.toggleLike(post),
            onDoubleLike: () => controller.likePost(post),
            onSave: () => controller.toggleSave(post),
            onFollow: () => controller.toggleFollow(post.author),
            onComment: () => controller.openComments(post),
            onRepost: () => controller.toggleRepost(post),
            onShare: () => controller.openShare(post),
            onMore: () => controller.openPostMenu(post),
          );
        }),
      ),
    );
  }
}
