import 'user_model.dart';

/// A single conversation row in the messages list.
class MessageModel {
  final int id;
  final UserModel user;
  final String lastMessage;
  final String timeAgo;
  final int unread;
  final bool isOnline;

  /// Whether the last message was sent by me (shows "You: ").
  final bool sentByMe;

  MessageModel({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.timeAgo,
    this.unread = 0,
    this.isOnline = false,
    this.sentByMe = false,
  });
}
