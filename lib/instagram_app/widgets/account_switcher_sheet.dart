import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/dummy_data_service.dart';
import '../utils/app_colors.dart';
import 'user_avatar.dart';

/// Instagram-style account switcher bottom sheet.
class AccountSwitcherSheet extends StatelessWidget {
  const AccountSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.find<DummyDataService>();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: UserAvatar(imageUrl: data.currentUser.avatarUrl, size: 44),
            title: Obx(
              () => Text(
                data.meUsername.value,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            trailing: const Icon(Icons.check_circle, color: AppColors.primary),
          ),
          const Divider(height: 1, color: AppColors.divider),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 22),
            child: Text(
              'No more accounts available.',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
