import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/story_model.dart';
import '../../routes/app_routes.dart';
import '../../services/dummy_data_service.dart';
import '../../utils/app_colors.dart';
import '../home/home_controller.dart';
import '../share/share_controller.dart';
import '../share/share_sheet.dart';

/// Drives the story viewer: progress animation, pause/resume, prev/next and the
/// reply flow. Owns its [AnimationController] and disposes it in [onClose].
class StoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final DummyDataService _data = Get.find<DummyDataService>();

  late final AnimationController progress;
  final TextEditingController replyInput = TextEditingController();

  late final List<StoryModel> stories;
  final RxInt index = 0.obs;
  final RxBool isPaused = false.obs;
  final RxBool replyMode = false.obs;
  final RxBool liked = false.obs;

  StoryModel get current => stories[index.value];

  @override
  void onInit() {
    super.onInit();
    stories = _data.orderedStories;
    final arg = Get.arguments;
    index.value =
        (arg is int && arg >= 0 && arg < stories.length) ? arg : 0;
    progress = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) next();
      });
  }

  @override
  void onReady() {
    super.onReady();
    // Runs after the first frame -> safe to mutate observed state.
    _startCurrent();
  }

  void _startCurrent() {
    liked.value = false;
    _markViewed();
    progress.forward(from: 0);
  }

  void _markViewed() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().markStoryViewed(current.user.id);
    }
  }

  // --- Navigation (gesture-driven, never during build) -----------------------

  void next() {
    if (index.value < stories.length - 1) {
      index.value++;
      _startCurrent();
    } else {
      Get.back();
    }
  }

  void prev() {
    if (index.value > 0) {
      index.value--;
      _startCurrent();
    } else {
      progress.forward(from: 0);
    }
  }

  void pause() {
    if (replyMode.value) return;
    progress.stop();
    isPaused.value = true;
  }

  void resume() {
    if (replyMode.value) return;
    progress.forward();
    isPaused.value = false;
  }

  // --- Reply -----------------------------------------------------------------

  void openReply() {
    if (replyMode.value) return;
    replyMode.value = true;
    progress.stop();
  }

  void closeReply() {
    if (!replyMode.value) return;
    replyMode.value = false;
    replyInput.clear();
    progress.forward();
  }

  void toggleLike() => liked.toggle();

  void sendReply() {
    final text = replyInput.text.trim();
    if (text.isNotEmpty) {
      _data.addStoryReply(current.user, text);
    }
    replyInput.clear();
    replyMode.value = false;
    progress.forward();
    if (text.isNotEmpty) {
      Get.snackbar(
        'Sent',
        'Reply sent to ${current.user.username}',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void share() {
    pause();
    Get.put(ShareController(profile: current.user));
    Get.bottomSheet(
      const ShareSheet(),
      isScrollControlled: true,
      backgroundColor: AppColors.white,
    ).whenComplete(() {
      Get.delete<ShareController>();
      resume();
    });
  }

  void openProfile() => Get.toNamed(AppRoutes.userProfile, arguments: current.user);

  @override
  void onClose() {
    progress.dispose();
    replyInput.dispose();
    super.onClose();
  }
}
