import 'package:get/get.dart';

import '../screen/chat/chat_detail_screen.dart';
import '../screen/create_post/create_post_screen.dart';
import '../screen/edit_profile/edit_profile_screen.dart';
import '../screen/main/main_screen.dart';
import '../screen/notification/notification_screen.dart';
import '../screen/post_detail/post_detail_screen.dart';
import '../screen/story/story_viewer_screen.dart';
import '../screen/user_profile/user_profile_screen.dart';
import 'app_bindings.dart';
import 'app_routes.dart';

/// GetX page table for the Instagram demo app.
class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatDetailScreen(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.createPost,
      page: () => const CreatePostScreen(),
      binding: CreatePostBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.userProfile,
      page: () => const UserProfileScreen(),
      binding: UserProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.story,
      page: () => const StoryViewerScreen(),
      binding: StoryBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.postDetail,
      page: () => const PostDetailScreen(),
      binding: PostDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
