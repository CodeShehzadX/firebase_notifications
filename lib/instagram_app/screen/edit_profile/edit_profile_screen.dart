import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../widgets/user_avatar.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.find<EditProfileController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.close, color: AppColors.black),
        ),
        title: const Text(
          'Edit profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.save,
            icon: const Icon(Icons.check, color: AppColors.primary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                UserAvatar(imageUrl: controller.avatarUrl, size: 92),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Get.snackbar(
                    'Photo',
                    'Change profile photo — dummy action',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(12),
                  ),
                  child: const Text(
                    'Change profile photo',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _field('Name', controller.nameController),
          _field('Username', controller.usernameController),
          _field('Bio', controller.bioController, maxLines: 3),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.grey, fontSize: 13),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 16, color: AppColors.black),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.lightGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
