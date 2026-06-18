import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/stat_column.dart';
import '../../widgets/svg_icon.dart';
import '../../widgets/user_avatar.dart';
import 'reels_controller.dart';

/// Instagram-style vertical reels feed.
class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReelsController controller = Get.find<ReelsController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        onPageChanged: controller.onPageChanged,
        itemCount: controller.reels.length,
        itemBuilder: (context, index) => _reelPage(controller, index),
      ),
    );
  }

  Widget _reelPage(ReelsController controller, int index) {
    final PostModel reel = controller.reels[index];
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: reel.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (_, __) => const ColoredBox(color: Colors.black),
          errorWidget: (_, __, ___) => const ColoredBox(color: Colors.black),
        ),
        // Bottom gradient for legibility.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
        ),
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reels',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(Icons.camera_alt_outlined, color: AppColors.white),
              ],
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 24,
          child: _actions(controller, index),
        ),
        Positioned(
          left: 14,
          right: 80,
          bottom: 28,
          child: _info(reel),
        ),
      ],
    );
  }

  Widget _actions(ReelsController controller, int index) {
    return Obx(() {
      final PostModel reel = controller.reels[index];
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _actionButton(
            reel.isLiked ? AppAssets.heartFill : AppAssets.heart,
            StatColumn.formatCount(reel.likes),
            onTap: () => controller.toggleLike(reel),
            color: reel.isLiked ? AppColors.red : AppColors.white,
          ),
          _actionButton(
            AppAssets.comment,
            StatColumn.formatCount(reel.comments),
            onTap: () => controller.openComments(reel),
          ),
          _actionButton(
            AppAssets.share,
            'Share',
            onTap: () => controller.openShare(reel),
          ),
          _actionButton(
            reel.isReposted ? AppAssets.check : AppAssets.repost,
            'Repost',
            onTap: () => controller.toggleRepost(reel),
            color: reel.isReposted ? const Color(0xFF2ECC71) : AppColors.white,
          ),
          IconButton(
            onPressed: () => controller.openPostMenu(reel),
            icon: const SvgIcon(AppAssets.moreVert, size: 24,
                color: AppColors.white),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () =>
                Get.toNamed(AppRoutes.userProfile, arguments: reel.author),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              child: UserAvatar(imageUrl: reel.author.avatarUrl, size: 30),
            ),
          ),
        ],
      );
    });
  }

  Widget _actionButton(
    String asset,
    String label, {
    required VoidCallback onTap,
    Color color = AppColors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            SvgIcon(asset, size: 28, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: AppColors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(PostModel reel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () =>
              Get.toNamed(AppRoutes.userProfile, arguments: reel.author),
          child: Row(
            children: [
              UserAvatar(imageUrl: reel.author.avatarUrl, size: 32),
              const SizedBox(width: 8),
              Text(
                reel.author.username,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Follow',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          reel.caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.white, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.music_note, color: AppColors.white, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                reel.music,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
