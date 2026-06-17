import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_message_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../services/dummy_data_service.dart';

class ChatController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();

  /// The conversation passed in via Get.toNamed(arguments: ...).
  final MessageModel conversation = Get.arguments as MessageModel;

  late final RxList<ChatMessageModel> messages;
  final TextEditingController input = TextEditingController();

  UserModel get user => conversation.user;

  @override
  void onInit() {
    super.onInit();
    messages = _data.chatThread().obs;
  }

  void send() {
    final text = input.text.trim();
    if (text.isEmpty) return;
    messages.add(
      ChatMessageModel(
        id: messages.length + 600,
        text: text,
        isSent: true,
        time: 'now',
      ),
    );
    input.clear();
  }

  @override
  void onClose() {
    input.dispose();
    super.onClose();
  }
}
