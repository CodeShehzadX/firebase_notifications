import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../widgets/profile_view.dart';
import '../../widgets/svg_icon.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: GestureDetector(
          onTap: controller.openAccountSwitcher,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  controller.username.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 22),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.createPost),
            icon: const SvgIcon(AppAssets.add, size: 26),
          ),
          IconButton(
            onPressed: controller.openMenu,
            icon: const Icon(Icons.menu, size: 26),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => ProfileView(
          user: controller.user,
          name: controller.displayName.value,
          bio: controller.bio.value,
          posts: controller.posts,
          repostedPosts: controller.repostedPosts,
          selectedTab: controller.selectedTab.value,
          onTabChange: controller.changeTab,
          actionButton: Row(
            children: [
              Expanded(
                child: _outlinedButton(
                    AppStrings.editProfile, controller.editProfile),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _outlinedButton(
                    AppStrings.shareProfile, controller.shareProfile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _outlinedButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}
