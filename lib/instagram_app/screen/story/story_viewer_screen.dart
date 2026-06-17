import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/user_avatar.dart';
import '../home/home_controller.dart';

/// A simple full-screen story viewer with an auto-advancing progress bar.
class StoryViewerScreen extends StatefulWidget {
  const StoryViewerScreen({super.key});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late final UserModel user;
  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    user = Get.arguments as UserModel;
    // Mark the story as viewed after this frame so we don't mutate the
    // home feed's observed state during the build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().markStoryViewed(user.id);
      }
    });
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) Get.back();
      })
      ..forward();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: Get.back,
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/seed/story_${user.id}/800/1400',
                fit: BoxFit.cover,
                placeholder: (_, __) => const ColoredBox(color: Colors.black26),
                errorWidget: (_, __, ___) =>
                    const ColoredBox(color: Colors.black26),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _progress,
                      builder: (_, __) => LinearProgressIndicator(
                        value: _progress.value,
                        minHeight: 2.5,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        UserAvatar(imageUrl: user.avatarUrl, size: 36),
                        const SizedBox(width: 10),
                        Text(
                          user.username,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: Get.back,
                          icon: const Icon(Icons.close, color: AppColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
