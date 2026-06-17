import 'comment_model.dart';
import 'user_model.dart';

enum PostType { image, text }

/// A single feed post. Can be an image post or a text-only post.
class PostModel {
  final int id;
  final UserModel author;
  final PostType type;
  final String? imageUrl;
  final String caption;
  final String location;
  final String timeAgo;

  /// Background color (ARGB int) used to render text-only posts.
  final int textBgColor;

  /// Actual comments shown in the comments sheet.
  final List<CommentModel> commentList;

  // Mutable for like / save / repost toggles in the demo.
  int likes;
  int comments;
  bool isLiked;
  bool isSaved;
  bool isReposted;

  PostModel({
    required this.id,
    required this.author,
    required this.type,
    this.imageUrl,
    this.caption = '',
    this.location = '',
    this.timeAgo = '',
    this.textBgColor = 0xFF262626,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.isReposted = false,
    List<CommentModel>? commentList,
  }) : commentList = commentList ?? <CommentModel>[];

  bool get isImage => type == PostType.image;
  bool get isText => type == PostType.text;
}
