import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/story_model.dart';
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
    return Container(
      height: 116,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Obx(() {
        final others = controller.otherStories;
        final bool hasMine = controller.myStory.value != null;
        final int offset = hasMine ? 1 : 0;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: others.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return _yourStory(controller, hasMine);
            final story = others[index - 1];
            return _otherStory(controller, story, offset + index - 1);
          },
        );
      }),
    );
  }

  Widget _yourStory(HomeController controller, bool hasMine) {
    return GestureDetector(
      onTap: () =>
          hasMine ? controller.openStoryAt(0) : controller.addStory(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                UserAvatar(
                  imageUrl: controller.me.avatarUrl,
                  size: 64,
                  hasStoryRing: hasMine,
                  viewed: controller.isStoryViewed(controller.me.id),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: controller.addStory,
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
                ),
              ],
            ),
            const SizedBox(height: 4),
            const SizedBox(
              width: 70,
              child: Text(
                AppStrings.yourStory,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherStory(
    HomeController controller,
    StoryModel story,
    int viewerIndex,
  ) {
    return GestureDetector(
      onTap: () => controller.openStoryAt(viewerIndex),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(
              imageUrl: story.user.avatarUrl,
              size: 64,
              hasStoryRing: true,
              viewed: controller.isStoryViewed(story.user.id),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 70,
              child: Text(
                story.user.username,
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
