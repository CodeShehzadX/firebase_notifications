import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/chat_message_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';

class ChatController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();
  final ImagePicker _picker = ImagePicker();

  /// The conversation passed in via Get.toNamed(arguments: ...).
  final MessageModel conversation = Get.arguments as MessageModel;

  late final RxList<ChatMessageModel> messages;
  final TextEditingController input = TextEditingController();

  UserModel get user => conversation.user;

  @override
  void onInit() {
    super.onInit();
    // Persistent, per-conversation thread.
    messages = _data.threadFor(conversation.id);
  }

  void send() {
    final text = input.text.trim();
    if (text.isEmpty) return;
    _data.sendTextToChat(conversation.id, text);
    input.clear();
  }

  /// Opens the camera and sends the captured photo to this conversation.
  Future<void> sendPhoto() async {
    final XFile? shot = await _picker.pickImage(source: ImageSource.camera);
    if (shot == null) return;
    _data.sendImageToChat(conversation.id, shot.path);
  }

  @override
  void onClose() {
    input.dispose();
    super.onClose();
  }
}
