import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import 'stat_column.dart';
import 'svg_icon.dart';
import 'user_avatar.dart';

/// Reusable profile body shared by the current-user profile and other-user
/// profile screens. The [actionButton] slot holds either the Edit/Share row
/// or a Follow/Following button.
class ProfileView extends StatelessWidget {
  final UserModel user;

  /// Display name + bio passed explicitly so the current-user profile can feed
  /// reactive (Rx-backed) values while other profiles pass static ones.
  final String name;
  final String bio;
  final List<PostModel> posts;
  final List<PostModel> repostedPosts;
  final int selectedTab;
  final ValueChanged<int> onTabChange;
  final Widget actionButton;

  const ProfileView({
    super.key,
    required this.user,
    required this.name,
    required this.bio,
    required this.posts,
    required this.repostedPosts,
    required this.selectedTab,
    required this.onTabChange,
    required this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _header(),
        _bio(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: actionButton,
        ),
        const SizedBox(height: 12),
        _tabBar(),
        _grid(),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          UserAvatar(imageUrl: user.avatarUrl, size: 88, hasStoryRing: true),
          const SizedBox(width: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatColumn(count: user.posts, label: AppStrings.posts),
                StatColumn(count: user.followers, label: AppStrings.followers),
                StatColumn(
                    count: user.following, label: AppStrings.followingLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bio() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          if (bio.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(bio, style: const TextStyle(fontSize: 13, height: 1.35)),
          ],
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Row(
      children: [
        _tabItem(0, AppAssets.grid),
        _tabItem(1, AppAssets.tag),
        _tabItem(2, AppAssets.repost),
      ],
    );
  }

  Widget _tabItem(int index, String asset) {
    final bool selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChange(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              top: const BorderSide(color: AppColors.divider),
              bottom: BorderSide(
                color: selected ? AppColors.black : Colors.transparent,
                width: 1.4,
              ),
            ),
          ),
          child: SvgIcon(
            asset,
            size: 24,
            color: selected ? AppColors.black : AppColors.grey,
          ),
        ),
      ),
    );
  }

  Widget _grid() {
    if (selectedTab == 1) {
      return _emptyState(AppAssets.tag, 'No photos yet');
    }
    if (selectedTab == 2) {
      if (repostedPosts.isEmpty) {
        return _emptyState(AppAssets.repost, 'No reposts yet');
      }
      return _imageGrid(repostedPosts);
    }
    return _imageGrid(posts);
  }

  Widget _emptyState(String asset, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          SvgIcon(asset, size: 48, color: AppColors.grey),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _imageGrid(List<PostModel> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final post = items[index];
        return GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.postDetail, arguments: post),
          child: CachedNetworkImage(
            imageUrl: post.imageUrl!,
            fit: BoxFit.cover,
            placeholder: (_, __) => const ColoredBox(color: AppColors.softGrey),
            errorWidget: (_, __, ___) =>
                const ColoredBox(color: AppColors.softGrey),
          ),
        );
      },
    );
  }
}
