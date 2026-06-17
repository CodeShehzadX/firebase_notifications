/// Represents an Instagram user (dummy data only).
class UserModel {
  final int id;
  final String username;
  final String fullName;
  final String avatarUrl;
  final String bio;
  final bool isMe;

  // Mutable so the demo can react to follow/like actions.
  int posts;
  int followers;
  int following;
  bool isFollowing;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.avatarUrl,
    this.bio = '',
    this.isMe = false,
    this.posts = 0,
    this.followers = 0,
    this.following = 0,
    this.isFollowing = false,
  });
}
