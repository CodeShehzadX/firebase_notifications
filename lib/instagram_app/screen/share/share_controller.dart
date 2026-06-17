import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';

class ShareController extends GetxController {
  final PostModel post;
  ShareController(this.post);

  final DummyDataService _data = Get.find<DummyDataService>();

  /// Ids of the selected recipients.
  final RxSet<int> selected = <int>{}.obs;

  List<UserModel> get users => _data.users;

  bool isSelected(UserModel user) => selected.contains(user.id);

  void toggle(UserModel user) {
    if (selected.contains(user.id)) {
      selected.remove(user.id);
    } else {
      selected.add(user.id);
    }
  }

  void send() {
    final targets = users.where((u) => selected.contains(u.id)).toList();
    if (targets.isEmpty) return;
    _data.sharePostToUsers(post, targets);
    Get.back();
    Get.snackbar(
      'Sent',
      'Post sent to ${targets.length} ${targets.length == 1 ? 'person' : 'people'}',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }
}
