import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/story_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/svg_icon.dart';
import '../../widgets/user_avatar.dart';
import 'story_controller.dart';

/// Full-screen Instagram-style story viewer:
/// hold to pause, tap left/right for prev/next, swipe-up / tap reply to open
/// the reply panel (blurred background), plus like / comment / share actions.
class StoryViewerScreen extends StatelessWidget {
  const StoryViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StoryController controller = Get.find<StoryController>();

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        final StoryModel story = controller.current;
        final bool replying = controller.replyMode.value;
        return Stack(
          children: [
            Positioned.fill(child: _content(story)),
            // Blur + dim when replying.
            if (replying)
              Positioned.fill(
                child: GestureDetector(
                  onTap: controller.closeReply,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(color: Colors.black.withValues(alpha: 0.45)),
                  ),
                ),
              ),
            // Gesture layer (below header/footer so their buttons still work).
            Positioned.fill(child: _gestureLayer(controller)),
            // Top progress bars + header.
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    _progressBars(controller),
                    const SizedBox(height: 10),
                    _header(controller, story),
                  ],
                ),
              ),
            ),
            // Bottom: reply panel when replying, else interaction row.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: replying
                  ? _replyPanel(controller, story)
                  : _bottomRow(controller, story),
            ),
          ],
        );
      }),
    );
  }

  Widget _content(StoryModel story) {
    if (story.isText) {
      return Container(
        color: Color(story.bgColor),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Text(
          story.text ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      );
    }
    if (story.imagePath != null) {
      return Image.file(
        File(story.imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black26),
      );
    }
    return CachedNetworkImage(
      imageUrl: story.imageUrl!,
      fit: BoxFit.cover,
      placeholder: (_, __) => const ColoredBox(color: Colors.black26),
      errorWidget: (_, __, ___) => const ColoredBox(color: Colors.black26),
    );
  }

  Widget _gestureLayer(StoryController controller) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) {
        if (details.localPosition.dx < Get.width * 0.30) {
          controller.prev();
        } else {
          controller.next();
        }
      },
      onLongPressStart: (_) => controller.pause(),
      onLongPressEnd: (_) => controller.resume(),
      onVerticalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) < -250) controller.openReply();
      },
    );
  }

  Widget _progressBars(StoryController controller) {
    return Obx(() {
      final int idx = controller.index.value;
      return Row(
        children: List.generate(controller.stories.length, (i) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  height: 2.5,
                  child: Stack(
                    children: [
                      const ColoredBox(color: Colors.white24),
                      if (i < idx)
                        const Positioned.fill(
                            child: ColoredBox(color: AppColors.white)),
                      if (i == idx)
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: controller.progress,
                            builder: (_, __) => FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: controller.progress.value,
                              child: const ColoredBox(color: AppColors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _header(StoryController controller, StoryModel story) {
    return Row(
      children: [
        GestureDetector(
          onTap: controller.openProfile,
          child: UserAvatar(imageUrl: story.user.avatarUrl, size: 34),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: controller.openProfile,
          child: Text(
            story.user.username,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('now', style: TextStyle(color: Colors.white70, fontSize: 12)),
        const Spacer(),
        IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.close, color: AppColors.white),
        ),
      ],
    );
  }

  Widget _bottomRow(StoryController controller, StoryModel story) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: controller.openReply,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 44,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Text(
                    'Reply to ${story.user.username}...',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
            Obx(
              () => IconButton(
                onPressed: controller.toggleLike,
                icon: SvgIcon(
                  controller.liked.value ? AppAssets.heartFill : AppAssets.heart,
                  size: 28,
                  color: controller.liked.value ? AppColors.red : AppColors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: controller.openReply,
              icon: const SvgIcon(AppAssets.comment, size: 26,
                  color: AppColors.white),
            ),
            IconButton(
              onPressed: controller.share,
              icon: const SvgIcon(AppAssets.share, size: 26,
                  color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _replyPanel(StoryController controller, StoryModel story) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: TextField(
                    controller: controller.replyInput,
                    autofocus: true,
                    style: const TextStyle(color: AppColors.white),
                    cursorColor: AppColors.white,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.sendReply(),
                    decoration: InputDecoration(
                      hintText: 'Reply to ${story.user.username}...',
                      hintStyle: const TextStyle(color: Colors.white60),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.sendReply,
                icon: const SvgIcon(AppAssets.share, size: 24,
                    color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
