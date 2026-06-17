import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/comment_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/user_avatar.dart';
import 'comments_controller.dart';

/// Bottom sheet showing a post's comments, with an input to add a new one.
class CommentsSheet extends StatelessWidget {
  const CommentsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final CommentsController controller = Get.find<CommentsController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
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
            const SizedBox(height: 10),
            const Text(
              'Comments',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const Divider(height: 16, color: AppColors.divider),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.comments.length,
                  itemBuilder: (context, index) =>
                      _commentTile(controller, controller.comments[index]),
                ),
              ),
            ),
            _inputBar(controller),
          ],
        );
      },
    );
  }

  Widget _commentTile(CommentsController controller, CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(imageUrl: comment.user.avatarUrl, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: AppColors.black, fontSize: 14, height: 1.3),
                    children: [
                      TextSpan(
                        text: '${comment.user.username} ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: comment.text),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      comment.timeAgo,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.grey),
                    ),
                    const SizedBox(width: 16),
                    if (comment.likes > 0)
                      Text(
                        '${comment.likes} likes',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.toggleLike(comment),
            child: Icon(
              comment.isLiked ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: comment.isLiked ? AppColors.red : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBar(CommentsController controller) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.input,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.addComment(),
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            TextButton(
              onPressed: controller.addComment,
              child: const Text(
                'Post',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
