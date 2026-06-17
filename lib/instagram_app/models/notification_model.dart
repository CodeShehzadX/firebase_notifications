import 'user_model.dart';

enum NotificationType { like, comment, follow, mention }

/// Time grouping shown as section headers on the notifications screen.
enum NotificationSection { today, thisWeek, earlier }

class NotificationModel {
  final int id;
  final UserModel user;
  final NotificationType type;
  final String text;
  final String timeAgo;

  /// Thumbnail of the related post (null for follow notifications).
  final String? postImageUrl;
  final NotificationSection section;

  bool isFollowing;

  NotificationModel({
    required this.id,
    required this.user,
    required this.type,
    required this.text,
    required this.timeAgo,
    required this.section,
    this.postImageUrl,
    this.isFollowing = false,
  });

  bool get isFollow => type == NotificationType.follow;
}
