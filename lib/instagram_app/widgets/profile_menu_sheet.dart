import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';

/// Instagram-style "Settings and activity" bottom sheet for the profile.
class ProfileMenuSheet extends StatelessWidget {
  const ProfileMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
            _item(Icons.settings_outlined, 'Settings and privacy'),
            _item(Icons.bookmark_border, 'Saved'),
            _item(Icons.history, 'Archive'),
            _item(Icons.bar_chart, 'Your activity'),
            _item(Icons.qr_code, 'QR code'),
            _item(Icons.person_add_alt, 'Close friends'),
            _item(Icons.logout, 'Log out', color: AppColors.red),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String label, {Color color = AppColors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color, fontSize: 15)),
      onTap: () {
        Get.back();
        Get.snackbar(
          label,
          'Dummy action',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        );
      },
    );
  }
}
