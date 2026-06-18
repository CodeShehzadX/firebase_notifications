import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../services/dummy_data_service.dart';
import '../common/post_actions_mixin.dart';

/// Reels reuse [PostModel] + [PostActionsMixin], so like / comment / share /
/// repost / menu behave exactly like feed posts.
class ReelsController extends GetxController with PostActionsMixin {
  final DummyDataService _data = Get.find<DummyDataService>();

  @override
  DummyDataService get postData => _data;

  @override
  void onPostChanged() => reels.refresh();

  late final RxList<PostModel> reels;
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    reels = _data.reels.obs;
  }

  void onPageChanged(int index) => currentPage.value = index;
}
