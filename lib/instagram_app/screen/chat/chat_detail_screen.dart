import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_message_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/svg_icon.dart';
import '../../widgets/user_avatar.dart';
import 'chat_controller.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();
    final user = controller.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 32,
        leading: IconButton(
          onPressed: Get.back,
          icon: const SvgIcon(AppAssets.back, size: 22),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () =>
                  Get.toNamed(AppRoutes.userProfile, arguments: user),
              child: Stack(
                children: [
                  UserAvatar(imageUrl: user.avatarUrl, size: 38),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const Text(
                  'Active now',
                  style: TextStyle(fontSize: 12, color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const SvgIcon(AppAssets.camera, size: 24),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) =>
                    _bubble(controller.messages[index]),
              ),
            ),
          ),
          _inputBar(controller),
        ],
      ),
    );
  }

  Widget _bubble(ChatMessageModel message) {
    final bool sent = message.isSent;
    return Align(
      alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: Get.width * 0.72),
        decoration: BoxDecoration(
          color: sent ? AppColors.primary : AppColors.softGrey,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(sent ? 18 : 4),
            bottomRight: Radius.circular(sent ? 4 : 18),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: sent ? AppColors.white : AppColors.black,
            fontSize: 14.5,
          ),
        ),
      ),
    );
  }

  Widget _inputBar(ChatController controller) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: TextField(
                  controller: controller.input,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => controller.send(),
                  decoration: const InputDecoration(
                    hintText: 'Message...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: controller.send,
              icon: const SvgIcon(AppAssets.share, size: 24,
                  color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
