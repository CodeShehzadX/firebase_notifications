import 'user_model.dart';

/// A single comment on a post.
class CommentModel {
  final int id;
  final UserModel user;
  final String text;
  final String timeAgo;

  int likes;
  bool isLiked;

  CommentModel({
    required this.id,
    required this.user,
    required this.text,
    this.timeAgo = 'now',
    this.likes = 0,
    this.isLiked = false,
  });
}
