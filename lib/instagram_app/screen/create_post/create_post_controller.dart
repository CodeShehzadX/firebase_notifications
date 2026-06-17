import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../services/dummy_data_service.dart';
import '../../utils/app_colors.dart';
import '../home/home_controller.dart';

class CreatePostController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();
  final HomeController _home = Get.find<HomeController>();

  /// true = text post mode, false = image post mode.
  final RxBool isTextMode = true.obs;
  final RxInt colorIndex = 0.obs;

  final TextEditingController textController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  /// Stand-in for a "picked" image.
  final String dummyImageUrl = 'https://picsum.photos/seed/newpost/700/700';

  List<int> get colors => AppColors.postBackgrounds;

  void setTextMode(bool value) => isTextMode.value = value;

  void selectColor(int index) => colorIndex.value = index;

  void share() {
    final me = _data.currentUser;
    final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final PostModel post = isTextMode.value
        ? PostModel(
            id: id,
            author: me,
            type: PostType.text,
            caption: textController.text.trim().isEmpty
                ? 'Hello world ✨'
                : textController.text.trim(),
            textBgColor: colors[colorIndex.value],
            timeAgo: 'now',
          )
        : PostModel(
            id: id,
            author: me,
            type: PostType.image,
            imageUrl: dummyImageUrl,
            caption: captionController.text.trim(),
            timeAgo: 'now',
          );

    _home.addPost(post);
    Get.back();
    Get.snackbar(
      'Posted',
      'Your post was added to the feed',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    textController.dispose();
    captionController.dispose();
    super.onClose();
  }
}
