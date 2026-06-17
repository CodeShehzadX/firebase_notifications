import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/post_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import 'stat_column.dart';
import 'svg_icon.dart';
import 'user_avatar.dart';

/// A single feed post rendered Instagram-style.
class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onDoubleLike;
  final VoidCallback onSave;
  final VoidCallback onFollow;
  final VoidCallback onComment;
  final VoidCallback onRepost;
  final VoidCallback onShare;
  final VoidCallback onMore;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onDoubleLike,
    required this.onSave,
    required this.onFollow,
    required this.onComment,
    required this.onRepost,
    required this.onShare,
    required this.onMore,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 40),
    ]).animate(_heartCtrl);
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
    ]).animate(_heartCtrl);
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    // Double-tap only likes (never unlikes); animation plays regardless.
    widget.onDoubleLike();
    _heartCtrl.forward(from: 0);
  }

  PostModel get post => widget.post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        _media(),
        _actions(),
        _likes(),
        _caption(),
        if (post.comments > 0) _viewComments(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Text(
            post.timeAgo == '1d' ? '1 day ago' : '${post.timeAgo} ago',
            style: const TextStyle(color: AppColors.grey, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    final author = post.author;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                Get.toNamed(AppRoutes.userProfile, arguments: author),
            child: UserAvatar(
                imageUrl: author.avatarUrl, size: 36, hasStoryRing: true),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.userProfile,
                            arguments: author),
                        child: Text(
                          author.username,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (!author.isMe) ...[
                      const SizedBox(width: 6),
                      const Text('•', style: TextStyle(color: AppColors.grey)),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: widget.onFollow,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          author.isFollowing ? 'Following' : 'Follow',
                          style: TextStyle(
                            color: author.isFollowing
                                ? AppColors.black
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (post.location.isNotEmpty)
                  Text(
                    post.location,
                    style: const TextStyle(fontSize: 11.5),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onMore,
            icon: const SvgIcon(AppAssets.more, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _media() {
    final Widget content = post.isImage && post.imageUrl != null
        ? AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: post.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  const ColoredBox(color: AppColors.softGrey),
              errorWidget: (_, __, ___) => const ColoredBox(
                color: AppColors.softGrey,
                child: Icon(Icons.broken_image, color: AppColors.grey),
              ),
            ),
          )
        : AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Color(post.textBgColor),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                post.caption,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          );

    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          content,
          _heartOverlay(),
        ],
      ),
    );
  }

  Widget _heartOverlay() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _heartCtrl,
        builder: (_, __) => Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: const Icon(
              Icons.favorite,
              color: AppColors.white,
              size: 110,
              shadows: [Shadow(color: Colors.black38, blurRadius: 16)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onLike,
            icon: SvgIcon(
              post.isLiked ? AppAssets.heartFill : AppAssets.heart,
              size: 26,
              color: post.isLiked ? AppColors.red : AppColors.black,
            ),
          ),
          IconButton(
            onPressed: widget.onComment,
            icon: const SvgIcon(AppAssets.comment, size: 26),
          ),
          _repostButton(),
          IconButton(
            onPressed: widget.onShare,
            icon: const SvgIcon(AppAssets.share, size: 26),
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.onSave,
            icon: SvgIcon(
              post.isSaved ? AppAssets.bookmarkFill : AppAssets.bookmark,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _repostButton() {
    final bool reposted = post.isReposted;
    return IconButton(
      onPressed: widget.onRepost,
      icon: AnimatedRotation(
        // Rotate 90° to the right when reposted.
        turns: reposted ? 0.25 : 0,
        duration: const Duration(milliseconds: 300),
        child: SvgIcon(
          reposted ? AppAssets.check : AppAssets.repost,
          size: 26,
          color: reposted ? const Color(0xFF2ECC71) : AppColors.black,
        ),
      ),
    );
  }

  Widget _likes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        '${StatColumn.formatCount(post.likes)} likes',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _caption() {
    if (post.isText || post.caption.isEmpty) return const SizedBox(height: 4);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.black, fontSize: 14),
          children: [
            TextSpan(
              text: '${post.author.username} ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: post.caption),
          ],
        ),
      ),
    );
  }

  Widget _viewComments() {
    return GestureDetector(
      onTap: widget.onComment,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        child: Text(
          'View all ${post.comments} comments',
          style: const TextStyle(color: AppColors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
