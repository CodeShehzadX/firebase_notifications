import 'package:get/get.dart';

import '../models/chat_message_model.dart';
import '../models/comment_model.dart';
import '../models/message_model.dart';
import '../models/notification_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

/// Provides all dummy/seed data for the demo app.
///
/// Per the project rules, screens and controllers read their data from this
/// service instead of building data inline.
class DummyDataService extends GetxService {
  late final UserModel currentUser;
  late final List<UserModel> users;
  late final List<PostModel> feedPosts;
  late final List<PostModel> myPosts;
  late final List<NotificationModel> notifications;
  late final List<UserModel> suggestions;

  /// Reactive so the messages screen updates when a post is shared or a photo
  /// is captured.
  final RxList<MessageModel> messages = <MessageModel>[].obs;

  /// Posts the current user has reposted (shown on the profile repost tab).
  final List<PostModel> myReposts = [];

  static String _avatar(int n) => 'https://i.pravatar.cc/300?img=$n';
  static String _photo(String seed) =>
      'https://picsum.photos/seed/$seed/700/700';

  @override
  void onInit() {
    super.onInit();
    _seed();
  }

  void _seed() {
    currentUser = UserModel(
      id: 0,
      username: 'alex.dev',
      fullName: 'Alex Carter',
      avatarUrl: _avatar(12),
      bio: '📱 Flutter Developer\n🚀 Building beautiful apps\n📍 San Francisco, CA',
      isMe: true,
      posts: 9,
      followers: 1240,
      following: 312,
    );

    final john = UserModel(
      id: 1,
      username: 'john_doe',
      fullName: 'John Doe',
      avatarUrl: _avatar(11),
      isFollowing: true,
      posts: 84,
      followers: 5400,
      following: 410,
    );
    final sara = UserModel(
      id: 2,
      username: 'sara.smith',
      fullName: 'Sara Smith',
      avatarUrl: _avatar(5),
      isFollowing: false,
      posts: 120,
      followers: 18200,
      following: 280,
    );
    final mike = UserModel(
      id: 3,
      username: 'mike.codes',
      fullName: 'Mike Johnson',
      avatarUrl: _avatar(8),
      isFollowing: true,
      posts: 64,
      followers: 3100,
      following: 520,
    );
    final emma = UserModel(
      id: 4,
      username: 'emma.w',
      fullName: 'Emma Wilson',
      avatarUrl: _avatar(9),
      isFollowing: false,
      posts: 230,
      followers: 92000,
      following: 190,
    );
    final david = UserModel(
      id: 5,
      username: 'david.k',
      fullName: 'David Kim',
      avatarUrl: _avatar(13),
      isFollowing: true,
      posts: 41,
      followers: 2200,
      following: 360,
    );
    final lisa = UserModel(
      id: 6,
      username: 'lisa.ray',
      fullName: 'Lisa Ray',
      avatarUrl: _avatar(10),
      isFollowing: false,
      posts: 310,
      followers: 145000,
      following: 95,
    );

    users = [john, sara, mike, emma, david, lisa];

    feedPosts = [
      PostModel(
        id: 101,
        author: john,
        type: PostType.image,
        imageUrl: _photo('mountains1'),
        caption: 'Morning hikes hit different 🌄 #nature #adventure',
        location: 'Swiss Alps',
        timeAgo: '2h',
        likes: 1240,
        comments: 89,
      ),
      PostModel(
        id: 102,
        author: sara,
        type: PostType.text,
        caption:
            'Just shipped my first app to the store after 6 months of work.\n\nNever give up on what you start. 🚀',
        timeAgo: '4h',
        textBgColor: 0xFF3897F0,
        likes: 542,
        comments: 64,
      ),
      PostModel(
        id: 103,
        author: mike,
        type: PostType.image,
        imageUrl: _photo('desksetup'),
        caption: 'New setup, who dis? 💻⌨️',
        location: 'Home Office',
        timeAgo: '6h',
        likes: 873,
        comments: 45,
      ),
      PostModel(
        id: 104,
        author: emma,
        type: PostType.image,
        imageUrl: _photo('coffee2'),
        caption: 'Coffee and code ☕️ the perfect combo',
        location: 'Blue Bottle Coffee',
        timeAgo: '8h',
        likes: 2100,
        comments: 132,
      ),
      PostModel(
        id: 105,
        author: david,
        type: PostType.text,
        caption: 'Reminder:\n\nProgress > Perfection. ✨',
        timeAgo: '12h',
        textBgColor: 0xFFED4956,
        likes: 410,
        comments: 22,
      ),
      PostModel(
        id: 106,
        author: lisa,
        type: PostType.image,
        imageUrl: _photo('citynight'),
        caption: 'Lost in the city lights ✨ #tokyo #nightphotography',
        location: 'Tokyo, Japan',
        timeAgo: '1d',
        likes: 3400,
        comments: 210,
      ),
    ];

    myPosts = List.generate(
      9,
      (i) => PostModel(
        id: 200 + i,
        author: currentUser,
        type: PostType.image,
        imageUrl: _photo('mypost$i'),
        caption: 'Throwback to a good day 📸 #${i + 1}',
        timeAgo: '${i + 1}d',
        likes: 120 + i * 37,
        comments: 8 + i * 3,
      ),
    );

    notifications = [
      NotificationModel(
        id: 301,
        user: sara,
        type: NotificationType.like,
        text: 'liked your photo.',
        timeAgo: '1h',
        section: NotificationSection.today,
        postImageUrl: _photo('mypost1'),
      ),
      NotificationModel(
        id: 302,
        user: emma,
        type: NotificationType.follow,
        text: 'started following you.',
        timeAgo: '3h',
        section: NotificationSection.today,
        isFollowing: false,
      ),
      NotificationModel(
        id: 303,
        user: john,
        type: NotificationType.comment,
        text: 'commented: "This is amazing! 🔥🔥🔥"',
        timeAgo: '5h',
        section: NotificationSection.today,
        postImageUrl: _photo('mypost2'),
      ),
      NotificationModel(
        id: 304,
        user: mike,
        type: NotificationType.like,
        text: 'and 12 others liked your post.',
        timeAgo: '2d',
        section: NotificationSection.thisWeek,
        postImageUrl: _photo('mypost3'),
      ),
      NotificationModel(
        id: 305,
        user: david,
        type: NotificationType.mention,
        text: 'mentioned you in a comment.',
        timeAgo: '3d',
        section: NotificationSection.thisWeek,
        postImageUrl: _photo('mypost4'),
      ),
      NotificationModel(
        id: 306,
        user: lisa,
        type: NotificationType.follow,
        text: 'started following you.',
        timeAgo: '4d',
        section: NotificationSection.thisWeek,
        isFollowing: false,
      ),
      NotificationModel(
        id: 307,
        user: sara,
        type: NotificationType.like,
        text: 'liked your photo.',
        timeAgo: '2w',
        section: NotificationSection.earlier,
        postImageUrl: _photo('mypost5'),
      ),
    ];

    messages.addAll([
      MessageModel(
        id: 401,
        user: john,
        lastMessage: 'Hey, are we still on for tomorrow?',
        timeAgo: '2m',
        unread: 1,
        isOnline: true,
      ),
      MessageModel(
        id: 402,
        user: mike,
        lastMessage: 'Sent the project files 📎',
        timeAgo: '1h',
        isOnline: true,
      ),
      MessageModel(
        id: 403,
        user: emma,
        lastMessage: 'sounds good, talk soon!',
        timeAgo: '3h',
        sentByMe: true,
      ),
      MessageModel(
        id: 404,
        user: sara,
        lastMessage: 'Haha that\'s hilarious 😂',
        timeAgo: '5h',
        unread: 2,
      ),
      MessageModel(
        id: 405,
        user: david,
        lastMessage: 'Thanks for the help today 🙏',
        timeAgo: '1d',
      ),
      MessageModel(
        id: 406,
        user: lisa,
        lastMessage: 'Did you see the new update?',
        timeAgo: '2d',
      ),
    ]);

    suggestions = [sara, emma, lisa];

    _seedComments();
  }

  /// Attaches a few dummy comments to each feed post.
  void _seedComments() {
    const texts = [
      'This is amazing! 🔥',
      'Love this 😍',
      'Where is this? 👀',
      'Goals 🙌',
      'So clean 👌',
      'Incredible shot 📸',
    ];
    for (int p = 0; p < feedPosts.length; p++) {
      final post = feedPosts[p];
      for (int c = 0; c < 3; c++) {
        final author = users[(p + c) % users.length];
        post.commentList.add(
          CommentModel(
            id: post.id * 10 + c,
            user: author,
            text: texts[(p + c) % texts.length],
            timeAgo: '${c + 1}h',
            likes: (c + 1) * 4,
          ),
        );
      }
    }
  }

  /// A dummy chat thread of alternating received/sent messages.
  List<ChatMessageModel> chatThread() {
    const texts = [
      'Hey! How\'s it going? 😊',
      'Pretty good! Just shipping a new feature 🚀',
      'Nice! The Flutter one?',
      'Yeah, the Instagram clone 📱',
      'That sounds awesome 🔥',
      'Thanks! Almost done with the UI',
      'Can I see a preview?',
      'Sure, sending it over in a bit',
      'Perfect, take your time',
      'Just pushed it to the repo ✅',
      'You\'re fast! 😄',
      'Haha, gotta keep the momentum going',
    ];
    return [
      for (int i = 0; i < texts.length; i++)
        ChatMessageModel(
          id: 500 + i,
          text: texts[i],
          // Odd indexes are sent by me, so the thread starts with a received.
          isSent: i.isOdd,
          time: '10:${(30 + i).toString().padLeft(2, '0')}',
        ),
    ];
  }

  /// Dummy reposts (other people's posts) shown on another user's profile.
  List<PostModel> repostsForUser(UserModel user) {
    final others = users.where((u) => u.id != user.id).take(3).toList();
    return [
      for (final o in others)
        PostModel(
          id: 70000 + user.id * 10 + o.id,
          author: o,
          type: PostType.image,
          imageUrl: _photo('repost_${user.id}_${o.id}'),
          timeAgo: 'now',
          likes: 80 + o.id * 11,
          comments: 5 + o.id,
        ),
    ];
  }

  /// Shares [post] to the given users by updating their conversations and
  /// moving them to the top of the messages list.
  void sharePostToUsers(PostModel post, List<UserModel> targets) {
    for (final user in targets) {
      messages.removeWhere((m) => m.user.id == user.id);
      messages.insert(
        0,
        MessageModel(
          id: 80000 + user.id,
          user: user,
          lastMessage: 'Sent a post 📷',
          timeAgo: 'now',
          sentByMe: true,
        ),
      );
    }
  }

  /// Adds a dummy outgoing photo message to the top conversation.
  void addOutgoingPhotoMessage() {
    if (messages.isEmpty) return;
    final first = messages.first;
    messages[0] = MessageModel(
      id: first.id,
      user: first.user,
      lastMessage: '📷 Photo',
      timeAgo: 'now',
      sentByMe: true,
      isOnline: first.isOnline,
    );
  }

  /// A dummy 3x3 grid of image posts for any given user's profile.
  List<PostModel> postsForUser(UserModel user) {
    return List.generate(
      9,
      (i) => PostModel(
        id: user.id * 1000 + i,
        author: user,
        type: PostType.image,
        imageUrl: _photo('${user.username}$i'),
        timeAgo: '${i + 1}d',
        likes: 50 + i * 23,
        comments: 3 + i * 2,
      ),
    );
  }
}
