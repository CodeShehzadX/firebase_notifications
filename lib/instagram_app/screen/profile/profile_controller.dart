import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';

class ProfileController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();

  /// 0 = grid posts, 1 = tagged.
  final RxInt selectedTab = 0.obs;

  UserModel get user => _data.currentUser;
  List<PostModel> get posts => _data.myPosts;
  List<PostModel> get repostedPosts => _data.myReposts;

  void changeTab(int index) => selectedTab.value = index;
}
