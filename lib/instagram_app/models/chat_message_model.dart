/// A single chat bubble inside the chat detail screen.
class ChatMessageModel {
  final int id;
  final String text;

  /// true = sent by me (blue, right-aligned), false = received (grey, left).
  final bool isSent;
  final String time;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isSent,
    required this.time,
  });
}
