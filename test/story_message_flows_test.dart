import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_application_2_test/instagram_app/instagram_app.dart';
import 'package:flutter_application_2_test/instagram_app/routes/app_routes.dart';
import 'package:flutter_application_2_test/instagram_app/screen/chat/chat_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/home/home_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/share/share_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/story/story_controller.dart';
import 'package:flutter_application_2_test/instagram_app/services/dummy_data_service.dart';

void main() {
  testWidgets('story viewer opens and next() marks each user viewed',
      (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();
    final home = Get.find<HomeController>();
    final ordered = data.orderedStories;

    Get.toNamed(AppRoutes.story, arguments: 0);
    await tester.pump(); // build + post-frame markViewed
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull, reason: 'opening story threw');

    final story = Get.find<StoryController>();
    for (int i = 0; i < ordered.length; i++) {
      expect(home.isStoryViewed(ordered[i].user.id), isTrue,
          reason: 'story $i user not marked viewed');
      if (i < ordered.length - 1) {
        story.next();
        await tester.pump();
      }
    }

    Get.back();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
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
    expect(tester.takeException(), isNull, reason: 'opening share sheet threw');

    final share = Get.find<ShareController>();
    final target = data.users.first;
    share.toggle(target);
    share.send();

    for (int i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    expect(tester.takeException(), isNull, reason: 'share send threw');
    expect(data.messages.first.user.id, target.id);
  });
}
