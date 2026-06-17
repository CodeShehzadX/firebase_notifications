import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';
import '../../utils/app_colors.dart';

class MessageController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController searchInput = TextEditingController();
  final RxString query = ''.obs;

  UserModel get me => _data.currentUser;

  /// Conversations filtered by the current search query.
  List<MessageModel> get messages {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return _data.messages;
    return _data.messages
        .where((m) =>
            m.user.username.toLowerCase().contains(q) ||
            m.user.fullName.toLowerCase().contains(q) ||
            m.lastMessage.toLowerCase().contains(q))
        .toList();
  }

  void onSearchChanged(String value) => query.value = value;

  void clearSearch() {
    searchInput.clear();
    query.value = '';
  }

  /// Opens the device camera and, if a photo is captured, previews it and
  /// lets the user send it as a dummy outgoing message.
  Future<void> openCamera() async {
    final XFile? shot = await _picker.pickImage(source: ImageSource.camera);
    if (shot == null) return;
    Get.dialog(_preview(shot.path));
  }

  void _sendCaptured() {
    _data.addOutgoingPhotoMessage();
    Get.back();
    Get.snackbar(
      'Sent',
      'Photo sent as a message',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  Widget _preview(String path) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Image.file(
              File(path),
              height: 320,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 320,
                child: Center(child: Icon(Icons.image, size: 48)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: Get.back,
                    child: const Text('Cancel',
                        style: TextStyle(color: AppColors.grey)),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: _sendCaptured,
                    child: const Text(
                      'Send',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    searchInput.dispose();
    super.onClose();
  }
}
