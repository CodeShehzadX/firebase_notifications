import 'package:get/get.dart';

import '../models/chat_message_model.dart';
import '../models/comment_model.dart';
import '../models/message_model.dart';
import '../models/notification_model.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';
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
  late final List<UserModel> suggestions;

  /// Reactive lists so screens update when data changes at runtime.
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxList<StoryModel> stories = <StoryModel>[].obs;

  /// The current user's own (most recent) added story.
  final Rxn<StoryModel> myStory = Rxn<StoryModel>();

  /// Reels reuse PostModel so they share the post action flows.
  final List<PostModel> reels = [];

  /// Posts the current user has reposted (shown on the profile repost tab).
  final List<PostModel> myReposts = [];

  /// Per-conversation chat threads, lazily created.
  final Map<int, RxList<ChatMessageModel>> _chatThreads = {};

  /// Reactive mirrors of the current user's editable profile fields.
  final RxString meName = ''.obs;
  final RxString meUsername = ''.obs;
  final RxString meBio = ''.obs;

  static String _avatar(int n) => 'https://i.pravatar.cc/300?img=$n';
  static String _photo(String seed) =>
      'https://picsum.photos/seed/$seed/700/700';

  @override
  void onInit() {
    super.onInit();
    _seed();
  }

  void _seed() {
    meName.value = 'Alex Carter';
    meUsername.value = 'alex.dev';
    meBio.value =
        '📱 Flutter Developer\n🚀 Building beautiful apps\n📍 San Francisco, CA';
    currentUser = UserModel(
      id: 0,
      username: meUsername.value,
      fullName: meName.value,
      avatarUrl: _avatar(12),
      bio: meBio.value,
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

    notifications.addAll([
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
    ]);

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
    _seedStoriesAndReels();
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

  // --- Stories ---------------------------------------------------------------

  /// Ordered stories for the viewer: the current user's story (if any) first.
  List<StoryModel> get orderedStories => [
        if (myStory.value != null) myStory.value!,
        ...stories,
      ];

  /// Sets the current user's story and surfaces it in the story row.
  void addStory(StoryModel story) => myStory.value = story;

  /// Records a story reply as a DM + an activity notification.
  void addStoryReply(UserModel storyUser, String text) {
    messages.removeWhere((m) => m.user.id == storyUser.id);
    messages.insert(
      0,
      MessageModel(
        id: 82000 + storyUser.id,
        user: storyUser,
        lastMessage: 'Replied to their story: $text',
        timeAgo: 'now',
        sentByMe: true,
      ),
    );
    notifications.insert(
      0,
      NotificationModel(
        id: 90000 + storyUser.id,
        user: storyUser,
        type: NotificationType.comment,
        text: 'Story reply sent: "$text"',
        timeAgo: 'now',
        section: NotificationSection.today,
      ),
    );
  }

  // --- Chat threads ----------------------------------------------------------

  /// The persistent message thread for a conversation, created on first use.
  RxList<ChatMessageModel> threadFor(int convId) =>
      _chatThreads.putIfAbsent(
          convId, () => RxList<ChatMessageModel>.from(chatThread()));

  void _appendChatMessage(int convId, ChatMessageModel message, String preview) {
    threadFor(convId).add(message);
    final idx = messages.indexWhere((m) => m.id == convId);
    if (idx != -1) {
      final conv = messages[idx];
      messages.removeAt(idx);
      messages.insert(
        0,
        MessageModel(
          id: conv.id,
          user: conv.user,
          lastMessage: preview,
          timeAgo: 'now',
          sentByMe: true,
          isOnline: conv.isOnline,
        ),
      );
    }
  }

  void sendTextToChat(int convId, String text) {
    _appendChatMessage(
      convId,
      ChatMessageModel(
        id: threadFor(convId).length + 700,
        text: text,
        isSent: true,
        time: 'now',
      ),
      text,
    );
  }

  void sendImageToChat(int convId, String path) {
    _appendChatMessage(
      convId,
      ChatMessageModel(
        id: threadFor(convId).length + 700,
        text: '',
        isSent: true,
        time: 'now',
        imagePath: path,
      ),
      '📷 Photo',
    );
  }

  // --- Profile ---------------------------------------------------------------

  /// Updates the current user's editable profile fields reactively.
  void updateProfile({
    required String name,
    required String username,
    required String bio,
  }) {
    meName.value = name;
    meUsername.value = username;
    meBio.value = bio;
    currentUser.fullName = name;
    currentUser.username = username;
    currentUser.bio = bio;
  }

  /// Shares a profile to the given users (updates the messages list).
  void shareProfileToUsers(UserModel profile, List<UserModel> targets) {
    for (final user in targets) {
      messages.removeWhere((m) => m.user.id == user.id);
      messages.insert(
        0,
        MessageModel(
          id: 81000 + user.id,
          user: user,
          lastMessage: 'Shared @${profile.username}\'s profile',
          timeAgo: 'now',
          sentByMe: true,
        ),
      );
    }
  }

  // --- Seeding ---------------------------------------------------------------

  static String _reelPhoto(String seed) =>
      'https://picsum.photos/seed/$seed/720/1280';

  void _seedStoriesAndReels() {
    stories.addAll([
      for (final u in suggestions)
        StoryModel(
          id: 600 + u.id,
          user: u,
          type: StoryType.image,
          imageUrl: _reelPhoto('story_${u.id}'),
        ),
    ]);

    reels.addAll([
      _reel(900, users[5], 'reel1', 'Chasing sunsets 🌅 #travel',
          'Original audio • Lisa Ray', 12400, 340),
      _reel(901, users[3], 'reel2', 'Latte art therapy ☕️',
          'Aesthetic vibes • trending', 8900, 210),
      _reel(902, users[2], 'reel3', 'Coding time-lapse 💻 #devlife',
          'lofi beats • chillhop', 5400, 120),
      _reel(903, users[1], 'reel4', '60-second pasta 🍝',
          'Cooking sounds • Sara', 23100, 540),
      _reel(904, users[0], 'reel5', 'Mountain trail run 🏔️',
          'Adventure mix • John', 15200, 410),
    ]);

    for (final reel in reels) {
      for (int c = 0; c < 2; c++) {
        reel.commentList.add(
          CommentModel(
            id: reel.id * 10 + c,
            user: users[c % users.length],
            text: c == 0 ? 'This is fire 🔥' : 'Saved! 🙌',
            timeAgo: '${c + 1}h',
            likes: (c + 1) * 6,
          ),
        );
      }
    }
  }

  PostModel _reel(int id, UserModel author, String seed, String caption,
      String music, int likes, int comments) {
    return PostModel(
      id: id,
      author: author,
      type: PostType.image,
      imageUrl: _reelPhoto(seed),
      caption: caption,
      music: music,
      timeAgo: '1d',
      likes: likes,
      comments: comments,
    );
  }
}
