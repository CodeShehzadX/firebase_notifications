import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// Instagram-style Follow / Following toggle button.
///
/// [dense] renders the compact variant used inside post headers; the default
/// renders the larger pill used in suggestions and the notifications list.
class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;
  final bool dense;
  final double? width;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onTap,
    this.dense = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isFollowing ? AppColors.softGrey : AppColors.primary;
    final Color fg = isFollowing ? AppColors.black : AppColors.white;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: dense ? 30 : 34,
        padding: EdgeInsets.symmetric(horizontal: dense ? 14 : 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: isFollowing
              ? Border.all(color: AppColors.lightGrey)
              : null,
        ),
        child: Text(
          isFollowing ? AppStrings.following : AppStrings.follow,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w600,
            fontSize: dense ? 13 : 14,
          ),
        ),
      ),
    );
  }
}
