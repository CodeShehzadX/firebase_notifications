import 'user_model.dart';

enum StoryType { image, text }

/// A single story shown in the story row / story viewer.
class StoryModel {
  final int id;
  final UserModel user;
  final StoryType type;

  /// Network image (dummy stories for other users).
  final String? imageUrl;

  /// Locally picked image path (a story the current user added).
  final String? imagePath;

  /// Text content for a text story.
  final String? text;

  /// Background color (ARGB int) for a text story.
  final int bgColor;

  StoryModel({
    required this.id,
    required this.user,
    required this.type,
    this.imageUrl,
    this.imagePath,
    this.text,
    this.bgColor = 0xFF262626,
  });

  bool get isText => type == StoryType.text;
}
