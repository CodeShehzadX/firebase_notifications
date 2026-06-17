import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/follow_button.dart';
import '../../widgets/profile_view.dart';
import '../../widgets/svg_icon.dart';
import 'user_profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();

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
        title: Text(
          controller.user.username,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const SvgIcon(AppAssets.more, size: 22),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        // Touch reactive values so follow + tab changes rebuild the view.
        final bool following = controller.isFollowing.value;
        controller.followers.value;
        return ProfileView(
          user: controller.user,
          posts: controller.posts,
          repostedPosts: controller.repostedPosts,
          selectedTab: controller.selectedTab.value,
          onTabChange: controller.changeTab,
          actionButton: SizedBox(
            width: double.infinity,
            child: FollowButton(
              isFollowing: following,
              onTap: controller.toggleFollow,
              width: double.infinity,
            ),
          ),
        );
      }),
    );
  }
}
