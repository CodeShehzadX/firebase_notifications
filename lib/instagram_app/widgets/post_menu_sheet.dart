import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';

/// The 3-dot post options bottom sheet ("Not interested" / "Report").
class PostMenuSheet extends StatelessWidget {
  const PostMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 8),
          _option(
            icon: Icons.not_interested,
            label: 'Not interested',
            message: 'You will see fewer posts like this',
          ),
          _option(
            icon: Icons.report_gmailerrorred,
            label: 'Report',
            message: 'Thanks for letting us know',
            color: AppColors.red,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _option({
    required IconData icon,
    required String label,
    required String message,
    Color color = AppColors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color, fontSize: 15)),
      onTap: () {
        Get.back();
        Get.snackbar(
          label,
          message,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        );
      },
    );
  }
}
