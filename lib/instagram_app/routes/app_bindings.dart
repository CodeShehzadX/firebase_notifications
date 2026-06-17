import 'package:get/get.dart';

import '../screen/chat/chat_controller.dart';
import '../screen/create_post/create_post_controller.dart';
import '../screen/home/home_controller.dart';
import '../screen/main/main_controller.dart';
import '../screen/message/message_controller.dart';
import '../screen/notification/notification_controller.dart';
import '../screen/profile/profile_controller.dart';
import '../screen/search/search_controller.dart';
import '../screen/user_profile/user_profile_controller.dart';
import '../services/dummy_data_service.dart';

/// Registers app-wide singletons available from app start.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DummyDataService>(DummyDataService(), permanent: true);
  }
}

/// Controllers for the bottom-navigation tabs.
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<SearchPageController>(() => SearchPageController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

class CreatePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePostController>(() => CreatePostController());
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileController>(() => UserProfileController());
  }
}
