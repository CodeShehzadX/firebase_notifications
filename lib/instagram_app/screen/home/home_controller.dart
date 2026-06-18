import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/post_model.dart';
import '../../models/story_model.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../services/dummy_data_service.dart';
import '../common/post_actions_mixin.dart';

class HomeController extends GetxController with PostActionsMixin {
  final DummyDataService _data = Get.find<DummyDataService>();
  final ImagePicker _picker = ImagePicker();

  @override
  DummyDataService get postData => _data;

  @override
  void onPostChanged() => posts.refresh();

  late final RxList<PostModel> posts;

  /// Ids of users whose story has been viewed this session.
  final RxSet<int> viewedStories = <int>{}.obs;

  UserModel get me => _data.currentUser;

  /// Stories of other users shown in the row.
  RxList<StoryModel> get otherStories => _data.stories;

  /// The current user's own story (null until one is added).
  Rxn<StoryModel> get myStory => _data.myStory;

  @override
  void onInit() {
    super.onInit();
    posts = _data.feedPosts.obs;
  }

  /// Prepends a newly created post to the front of the feed.
  void addPost(PostModel post) => posts.insert(0, post);

  // --- Stories ---------------------------------------------------------------

  bool isStoryViewed(int userId) => viewedStories.contains(userId);

  void markStoryViewed(int userId) => viewedStories.add(userId);

  /// Opens the story viewer at [index] within the ordered story list.
  void openStoryAt(int index) =>
      Get.toNamed(AppRoutes.story, arguments: index);

  /// Add-story flow: pick from gallery, else fall back to a dummy text story.
  Future<void> addStory() async {
    StoryModel? story;
    try {
      final XFile? picked =
          await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        story = StoryModel(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          user: me,
          type: StoryType.image,
          imagePath: picked.path,
        );
      }
    } catch (_) {
      // Picker unavailable -> fall back below.
    }
    story ??= _textStory();
    _data.addStory(story);
    openStoryAt(0);
  }

  /// Adds a dummy text story (also used as the picker fallback / for tests).
  void addTextStory() {
    _data.addStory(_textStory());
  }

  StoryModel _textStory() => StoryModel(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        user: me,
        type: StoryType.text,
        text: 'My story ✨',
        bgColor: 0xFF3897F0,
      );
}
