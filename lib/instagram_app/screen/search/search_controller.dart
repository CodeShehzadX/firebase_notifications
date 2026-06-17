import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';

/// Named `SearchPageController` to avoid clashing with Flutter Material's
/// built-in `SearchController`.
class SearchPageController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();

  final TextEditingController input = TextEditingController();
  final RxString query = ''.obs;

  /// All image posts used for the explore grid.
  List<PostModel> get _allPosts => [
        ..._data.feedPosts.where((p) => p.isImage),
        ..._data.myPosts,
      ];

  bool get isSearching => query.value.trim().isNotEmpty;

  List<UserModel> get filteredUsers {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return _data.users
        .where((u) =>
            u.username.toLowerCase().contains(q) ||
            u.fullName.toLowerCase().contains(q))
        .toList();
  }

  List<PostModel> get filteredPosts {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return _allPosts;
    return _allPosts
        .where((p) =>
            p.caption.toLowerCase().contains(q) ||
            p.author.username.toLowerCase().contains(q))
        .toList();
  }

  void onQueryChanged(String value) => query.value = value;

  void clear() {
    input.clear();
    query.value = '';
  }

  @override
  void onClose() {
    input.dispose();
    super.onClose();
  }
}
