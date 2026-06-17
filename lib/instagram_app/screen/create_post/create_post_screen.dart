import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import 'create_post_controller.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreatePostController controller = Get.find<CreatePostController>();

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
          'New post',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: controller.share,
            child: const Text(
              'Share',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _modeToggle(controller),
            const SizedBox(height: 20),
            if (controller.isTextMode.value)
              _textMode(controller)
            else
              _imageMode(controller),
          ],
        ),
      ),
    );
  }

  Widget _modeToggle(CreatePostController controller) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _modeTab(controller, label: 'Text', isText: true),
          _modeTab(controller, label: 'Photo', isText: false),
        ],
      ),
    );
  }

  Widget _modeTab(
    CreatePostController controller, {
    required String label,
    required bool isText,
  }) {
    final bool selected = controller.isTextMode.value == isText;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setTextMode(isText),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.black : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _textMode(CreatePostController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Color(controller.colors[controller.colorIndex.value]),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: TextField(
              controller: controller.textController,
              maxLines: null,
              textAlign: TextAlign.center,
              cursorColor: AppColors.white,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write something...',
                hintStyle: TextStyle(color: Colors.white70, fontSize: 22),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < controller.colors.length; i++)
              _swatch(controller, i),
          ],
        ),
      ],
    );
  }

  Widget _swatch(CreatePostController controller, int index) {
    final bool selected = controller.colorIndex.value == index;
    return GestureDetector(
      onTap: () => controller.selectColor(index),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Color(controller.colors[index]),
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.black : AppColors.lightGrey,
            width: selected ? 2.5 : 1,
          ),
        ),
      ),
    );
  }

  Widget _imageMode(CreatePostController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.snackbar(
            'Demo',
            'Image picker — dummy image used',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(12),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: controller.dummyImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const ColoredBox(color: AppColors.softGrey),
                    errorWidget: (_, __, ___) => const ColoredBox(
                      color: AppColors.softGrey,
                      child: Icon(Icons.image, color: AppColors.grey, size: 48),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_a_photo_outlined,
                          color: AppColors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller.captionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write a caption...',
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
