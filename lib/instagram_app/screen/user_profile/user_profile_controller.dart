import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';

class UserProfileController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();

  /// The user passed in via Get.toNamed(arguments: ...).
  final UserModel user = Get.arguments as UserModel;

  final RxInt selectedTab = 0.obs;
  final RxBool isFollowing = false.obs;
  final RxInt followers = 0.obs;

  late final List<PostModel> posts;
  late final List<PostModel> repostedPosts;

  @override
  void onInit() {
    super.onInit();
    posts = _data.postsForUser(user);
    repostedPosts = _data.repostsForUser(user);
    isFollowing.value = user.isFollowing;
    followers.value = user.followers;
  }

  void changeTab(int index) => selectedTab.value = index;

  void toggleFollow() {
    isFollowing.toggle();
    followers.value += isFollowing.value ? 1 : -1;
    // Keep the shared model in sync so the feed reflects the change.
    user.isFollowing = isFollowing.value;
    user.followers = followers.value;
  }
}
