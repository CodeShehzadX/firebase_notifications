import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/user_avatar.dart';
import 'share_controller.dart';

/// Bottom sheet to share a post to one or more dummy users.
class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareController controller = Get.find<ShareController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Share',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const Divider(height: 16, color: AppColors.divider),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) =>
                      _userTile(controller, controller.users[index]),
                ),
              ),
            ),
            _sendBar(controller),
          ],
        );
      },
    );
  }

  Widget _userTile(ShareController controller, UserModel user) {
    return Obx(() {
      final bool selected = controller.isSelected(user);
      return ListTile(
        onTap: () => controller.toggle(user),
        leading: UserAvatar(imageUrl: user.avatarUrl, size: 44),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          user.fullName,
          style: const TextStyle(color: AppColors.grey, fontSize: 12),
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.lightGrey,
              width: 1.5,
            ),
          ),
          child: selected
              ? const Icon(Icons.check, size: 16, color: AppColors.white)
              : null,
        ),
      );
    });
  }

  Widget _sendBar(ShareController controller) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(() {
          final int count = controller.selected.length;
          final bool enabled = count > 0;
          return SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: enabled ? controller.send : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.lightGrey,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                enabled ? 'Send ($count)' : 'Send',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          );
        }),
      ),
    );
  }
}
