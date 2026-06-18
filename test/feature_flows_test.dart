import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_application_2_test/instagram_app/instagram_app.dart';
import 'package:flutter_application_2_test/instagram_app/routes/app_routes.dart';
import 'package:flutter_application_2_test/instagram_app/screen/home/home_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/post_detail/post_detail_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/profile/profile_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/reels/reels_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/share/share_controller.dart';
import 'package:flutter_application_2_test/instagram_app/screen/story/story_controller.dart';
import 'package:flutter_application_2_test/instagram_app/services/dummy_data_service.dart';
import 'package:flutter_application_2_test/instagram_app/widgets/post_card.dart';

Future<void> _drain(WidgetTester tester) async {
  for (int i = 0; i < 3; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
}

void main() {
  testWidgets('add story (text fallback) appears and opens in the viewer',
      (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();
    final home = Get.find<HomeController>();

    expect(data.myStory.value, isNull);
    home.addTextStory();
    expect(data.myStory.value, isNotNull);
    expect(data.orderedStories.first.user.id, data.currentUser.id);

    home.openStoryAt(0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull);
    Get.back();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('story pause/resume stops and restarts progress', (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();

    Get.toNamed(AppRoutes.story, arguments: 0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final story = Get.find<StoryController>();

    expect(story.progress.isAnimating, isTrue);
    story.pause();
    await tester.pump();
    expect(story.isPaused.value, isTrue);
    expect(story.progress.isAnimating, isFalse);

    story.resume();
    await tester.pump();
    expect(story.isPaused.value, isFalse);
    expect(story.progress.isAnimating, isTrue);

    Get.back();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('story reply adds a message + notification', (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();

    Get.toNamed(AppRoutes.story, arguments: 0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final story = Get.find<StoryController>();

    final int msgBefore = data.messages.length;
    final int notifBefore = data.notifications.length;
    story.replyInput.text = 'Love this!';
    story.sendReply();
    await tester.pump();

    expect(story.replyMode.value, isFalse);
    expect(data.messages.length, greaterThan(msgBefore));
    expect(data.notifications.length, greaterThan(notifBefore));

    Get.back();
    await _drain(tester);
  });

  testWidgets('story swipe-up reply mode toggles and restores', (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();

    Get.toNamed(AppRoutes.story, arguments: 0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final story = Get.find<StoryController>();

    story.openReply();
    await tester.pump();
    expect(story.replyMode.value, isTrue);
    expect(story.progress.isAnimating, isFalse);

    story.closeReply();
    await tester.pump();
    expect(story.replyMode.value, isFalse);

    Get.back();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('reels page change + like toggle', (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final reels = Get.find<ReelsController>();

    reels.onPageChanged(2);
    expect(reels.currentPage.value, 2);

    final reel = reels.reels.first;
    final bool wasLiked = reel.isLiked;
    reels.toggleLike(reel);
    expect(reel.isLiked, !wasLiked);
  });

  testWidgets('profile account switcher shows "No more accounts"',
      (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final profile = Get.find<ProfileController>();

    profile.openAccountSwitcher();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('No more accounts available.'), findsOneWidget);

    Get.back();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('profile menu opens with options', (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final profile = Get.find<ProfileController>();

    profile.openMenu();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Settings and privacy'), findsOneWidget);

    Get.back();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('edit profile updates reflect reactively', (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();

    data.updateProfile(
        name: 'New Name', username: 'new.handle', bio: 'Updated bio');
    expect(data.meName.value, 'New Name');
    expect(data.meUsername.value, 'new.handle');
    expect(data.currentUser.fullName, 'New Name');
    expect(data.currentUser.username, 'new.handle');
    expect(data.currentUser.bio, 'Updated bio');
  });

  testWidgets('share profile sends to messages', (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();
    final profile = Get.find<ProfileController>();

    profile.shareProfile();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final share = Get.find<ShareController>();
    final int before = data.messages.length;
    share.toggle(data.users.first);
    share.send();
    await _drain(tester);

    expect(data.messages.length, greaterThanOrEqualTo(before));
    expect(data.messages.first.lastMessage.contains('profile'), isTrue);
  });

  testWidgets('opening a profile post shows PostCard and like works',
      (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();

    Get.toNamed(AppRoutes.postDetail, arguments: data.myPosts.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    // The feed (under the pushed route) also has PostCards, so >= 1.
    expect(find.byType(PostCard), findsWidgets);

    final detail = Get.find<PostDetailController>();
    final bool wasLiked = detail.post.value.isLiked;
    detail.toggleLike(detail.post.value);
    await tester.pump();
    expect(detail.post.value.isLiked, !wasLiked);

    Get.back();
    await tester.pump();
  });

  testWidgets('chat camera sends an image message to the conversation',
      (tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();
    final data = Get.find<DummyDataService>();

    final int convId = data.messages.first.id;
    final int before = data.threadFor(convId).length;
    data.sendImageToChat(convId, '/tmp/photo.jpg');

    expect(data.threadFor(convId).length, before + 1);
    expect(data.threadFor(convId).last.isImage, isTrue);
    expect(data.messages.first.id, convId);
  });
}
