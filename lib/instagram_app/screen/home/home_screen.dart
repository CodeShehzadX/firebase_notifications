import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../widgets/post_card.dart';
import '../../widgets/svg_icon.dart';
import '../../widgets/user_avatar.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.toNamed(AppRoutes.createPost),
          icon: const SvgIcon(AppAssets.add, size: 26),
        ),
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notifications),
            icon: const SvgIcon(AppAssets.heart, size: 26),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: controller.posts.length + 1,
          separatorBuilder: (_, i) =>
              i == 0 ? const SizedBox.shrink() : const SizedBox(height: 6),
          itemBuilder: (context, index) {
            if (index == 0) return _storiesBar(controller);
            final post = controller.posts[index - 1];
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
          },
        ),
      ),
    );
  }

  Widget _storiesBar(HomeController controller) {
    final stories = controller.stories;
    return Container(
      height: 116,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: stories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _storyItem(controller, controller.me, isMine: true);
          }
          return _storyItem(controller, stories[index - 1]);
        },
      ),
    );
  }

  Widget _storyItem(
    HomeController controller,
    UserModel user, {
    bool isMine = false,
  }) {
    final bool viewed = controller.isStoryViewed(user.id);
    return GestureDetector(
      onTap: () => controller.openStory(user),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                UserAvatar(
                  imageUrl: user.avatarUrl,
                  size: 64,
                  hasStoryRing: !isMine,
                  viewed: viewed,
                ),
                if (isMine)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(Icons.add,
                          size: 16, color: AppColors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 70,
              child: Text(
                isMine ? AppStrings.yourStory : user.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
