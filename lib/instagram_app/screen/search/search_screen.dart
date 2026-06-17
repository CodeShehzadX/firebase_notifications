import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../widgets/svg_icon.dart';
import '../../widgets/user_avatar.dart';
import 'search_controller.dart';

/// Explore + search screen. Empty query shows the explore grid; typing filters
/// dummy users and posts.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchPageController controller = Get.find<SearchPageController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: _searchField(controller),
      ),
      body: Obx(
        () => controller.isSearching
            ? _results(controller)
            : _exploreGrid(controller.filteredPosts),
      ),
    );
  }

  Widget _searchField(SearchPageController controller) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SvgIcon(AppAssets.search, size: 18, color: AppColors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.input,
              onChanged: controller.onQueryChanged,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: AppStrings.search,
                hintStyle: TextStyle(color: AppColors.grey),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Obx(
            () => controller.isSearching
                ? GestureDetector(
                    onTap: controller.clear,
                    child: const Icon(Icons.close,
                        size: 18, color: AppColors.grey),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _results(SearchPageController controller) {
    final users = controller.filteredUsers;
    final posts = controller.filteredPosts;

    if (users.isEmpty && posts.isEmpty) {
      return const Center(
        child: Text('No results found', style: TextStyle(color: AppColors.grey)),
      );
    }

    return ListView(
      children: [
        ...users.map(_userTile),
        if (posts.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Posts',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          _postsGrid(posts),
        ],
      ],
    );
  }

  Widget _userTile(UserModel user) {
    return ListTile(
      onTap: () => Get.toNamed(AppRoutes.userProfile, arguments: user),
      leading: UserAvatar(imageUrl: user.avatarUrl, size: 44),
      title: Text(
        user.username,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        user.fullName,
        style: const TextStyle(color: AppColors.grey, fontSize: 12),
      ),
    );
  }

  Widget _exploreGrid(List<PostModel> posts) {
    return _gridView(posts, scrollable: true);
  }

  Widget _postsGrid(List<PostModel> posts) {
    return _gridView(posts, scrollable: false);
  }

  Widget _gridView(List<PostModel> posts, {required bool scrollable}) {
    return GridView.builder(
      shrinkWrap: !scrollable,
      physics: scrollable ? null : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) => CachedNetworkImage(
        imageUrl: posts[index].imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => const ColoredBox(color: AppColors.softGrey),
        errorWidget: (_, __, ___) =>
            const ColoredBox(color: AppColors.softGrey),
      ),
    );
  }
}
