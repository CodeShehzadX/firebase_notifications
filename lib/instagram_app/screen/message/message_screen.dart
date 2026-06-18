import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/message_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../widgets/svg_icon.dart';
import '../../widgets/user_avatar.dart';
import 'message_controller.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MessageController controller = Get.find<MessageController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Obx(
              () => Text(
                controller.username.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
        actions: [
          IconButton(
            onPressed: controller.openCamera,
            icon: const SvgIcon(AppAssets.camera, size: 24),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _searchBar(controller),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.only(top: 4),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) =>
                    _tile(controller, controller.messages[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(MessageController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
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
                controller: controller.searchInput,
                onChanged: controller.onSearchChanged,
                decoration: const InputDecoration(
                  hintText: AppStrings.search,
                  hintStyle: TextStyle(color: AppColors.grey),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            Obx(
              () => controller.query.value.isNotEmpty
                  ? GestureDetector(
                      onTap: controller.clearSearch,
                      child: const Icon(Icons.close,
                          size: 18, color: AppColors.grey),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(MessageController controller, MessageModel message) {
    final bool unread = message.unread > 0;
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.chat, arguments: message),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Stack(
              children: [
                UserAvatar(imageUrl: message.user.avatarUrl, size: 56),
                if (message.isOnline)
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.user.fullName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${message.sentByMe ? 'You: ' : ''}${message.lastMessage}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: unread ? AppColors.black : AppColors.grey,
                            fontWeight:
                                unread ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '  · ${message.timeAgo}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (unread)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              IconButton(
                onPressed: () => controller.sendPhotoToChat(message),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const SvgIcon(AppAssets.camera,
                    size: 24, color: AppColors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
