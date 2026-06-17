import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Circular user avatar with an optional Instagram-style gradient story ring.
class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool hasStoryRing;

  /// When true (and [hasStoryRing] is set), the ring is grey instead of the
  /// colorful gradient — indicating the story has been viewed.
  final bool viewed;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.hasStoryRing = false,
    this.viewed = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.softGrey,
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => const ColoredBox(color: AppColors.softGrey),
        errorWidget: (_, __, ___) =>
            const Icon(Icons.person, color: AppColors.grey),
      ),
    );

    if (!hasStoryRing) return avatar;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: viewed
            ? null
            : const SweepGradient(colors: AppColors.storyGradient),
        color: viewed ? AppColors.lightGrey : null,
      ),
      child: Container(
        padding: const EdgeInsets.all(2.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
        child: avatar,
      ),
    );
  }
}
