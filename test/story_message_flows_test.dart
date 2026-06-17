import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_application_2_test/instagram_app/instagram_app.dart';
import 'package:flutter_application_2_test/instagram_app/routes/app_routes.dart';
import 'package:flutter_application_2_test/instagram_app/screen/chat/chat_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/home/home_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/share/share_controller.dart';
import 'package:flutter_application_2_test/instagram_app/services/dummy_data_service.dart';

void main() {
  testWidgets('opening every story works and marks it viewed (grey ring)',
      (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();
    final home = Get.find<HomeController>();

    for (final user in [data.currentUser, ...data.suggestions]) {
      Get.toNamed(AppRoutes.story, arguments: user);
      await tester.pump(); // build story screen + run post-frame callback
      await tester.pump(const Duration(milliseconds: 50));

      expect(tester.takeException(), isNull,
          reason: 'opening story for ${user.username} threw');
      // Viewed state recorded -> the home ring renders grey.
      expect(home.isStoryViewed(user.id), isTrue,
          reason: '${user.username} not marked viewed');

      Get.back();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    }
  });

  testWidgets('sending a chat message works without error', (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();

    Get.toNamed(AppRoutes.chat, arguments: data.messages.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull, reason: 'opening chat threw');

    final chat = Get.find<ChatController>();
    final int before = chat.messages.length;
    chat.input.text = 'Hello there';
    chat.send();
    await tester.pump();

    expect(tester.takeException(), isNull, reason: 'sending message threw');
    expect(chat.messages.length, before + 1);
  });

  testWidgets('sharing a post to DM works without GetX improper-use error',
      (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();
    final home = Get.find<HomeController>();

    home.openShare(data.feedPosts.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // The share sheet must build without "improper use of a GetX".
    expect(tester.takeException(), isNull, reason: 'opening share sheet threw');

    final share = Get.find<ShareController>();
    final target = data.users.first;
    share.toggle(target);
    share.send();

    // Drain the success snackbar's timer/animation.
    for (int i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    expect(tester.takeException(), isNull, reason: 'share send threw');
    // The shared conversation jumped to the top of the messages list.
    expect(data.messages.first.user.id, target.id);
  });
}
