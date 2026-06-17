import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/notification_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../widgets/follow_button.dart';
import '../../widgets/user_avatar.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Map<NotificationSection, String> _titles = {
    NotificationSection.today: AppStrings.today,
    NotificationSection.thisWeek: AppStrings.thisWeek,
    NotificationSection.earlier: AppStrings.earlier,
  };

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: const Text(
          AppStrings.notifications,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: Obx(() {
        // Touch the reactive list so Obx rebuilds on follow toggles.
        controller.notifications.length;
        return ListView(
          padding: const EdgeInsets.only(top: 4),
          children: [
            for (final section in NotificationSection.values)
              ..._buildSection(controller, section),
          ],
        );
      }),
    );
  }

  List<Widget> _buildSection(
    NotificationController controller,
    NotificationSection section,
  ) {
    final items = controller.sectionItems(section);
    if (items.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Text(
          _titles[section]!,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      ...items.map((item) => _tile(controller, item)),
    ];
  }

  Widget _tile(NotificationController controller, NotificationModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                Get.toNamed(AppRoutes.userProfile, arguments: item.user),
            child: UserAvatar(imageUrl: item.user.avatarUrl, size: 48),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    color: AppColors.black, fontSize: 14, height: 1.3),
                children: [
                  TextSpan(
                    text: item.user.username,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: item.text),
                  TextSpan(
                    text: '  ${item.timeAgo}',
                    style: const TextStyle(color: AppColors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _trailing(controller, item),
        ],
      ),
    );
  }

  Widget _trailing(NotificationController controller, NotificationModel item) {
    if (item.isFollow) {
      return FollowButton(
        isFollowing: item.isFollowing,
        onTap: () => controller.toggleFollow(item),
        width: 104,
      );
    }
    if (item.postImageUrl != null) {
      return SizedBox(
        width: 44,
        height: 44,
        child: CachedNetworkImage(
          imageUrl: item.postImageUrl!,
          fit: BoxFit.cover,
          placeholder: (_, __) => const ColoredBox(color: AppColors.softGrey),
          errorWidget: (_, __, ___) =>
              const ColoredBox(color: AppColors.softGrey),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
