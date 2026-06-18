import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/dummy_data_service.dart';
import '../home/home_controller.dart';

class EditProfileController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();

  late final TextEditingController nameController;
  late final TextEditingController usernameController;
  late final TextEditingController bioController;

  String get avatarUrl => _data.currentUser.avatarUrl;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: _data.meName.value);
    usernameController = TextEditingController(text: _data.meUsername.value);
    bioController = TextEditingController(text: _data.meBio.value);
  }

  void save() {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    _data.updateProfile(
      name: name.isEmpty ? _data.meName.value : name,
      username: username.isEmpty ? _data.meUsername.value : username,
      bio: bioController.text.trim(),
    );
    // Propagate to the live feed (my posts/comments show my username).
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().posts.refresh();
    }
    Get.back();
    Get.snackbar(
      'Saved',
      'Profile updated',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
