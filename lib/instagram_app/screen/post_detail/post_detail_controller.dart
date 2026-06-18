import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../services/dummy_data_service.dart';
import '../common/post_actions_mixin.dart';

class PostDetailController extends GetxController with PostActionsMixin {
  final DummyDataService _data = Get.find<DummyDataService>();

  @override
  DummyDataService get postData => _data;

  @override
  void onPostChanged() => post.refresh();

  /// The post passed in via Get.toNamed(arguments: ...).
  late final Rx<PostModel> post;

  @override
  void onInit() {
    super.onInit();
    post = (Get.arguments as PostModel).obs;
  }
}
