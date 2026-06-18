import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../services/dummy_data_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/account_switcher_sheet.dart';
import '../../widgets/profile_menu_sheet.dart';
import '../share/share_controller.dart';
import '../share/share_sheet.dart';

class ProfileController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();

  /// 0 = grid posts, 1 = tagged, 2 = reposts.
  final RxInt selectedTab = 0.obs;

  UserModel get user => _data.currentUser;
  List<PostModel> get posts => _data.myPosts;
  List<PostModel> get repostedPosts => _data.myReposts;

  // Reactive profile fields (updated by Edit Profile).
  RxString get displayName => _data.meName;
  RxString get username => _data.meUsername;
  RxString get bio => _data.meBio;

  void changeTab(int index) => selectedTab.value = index;

  void openAccountSwitcher() => Get.bottomSheet(
        const AccountSwitcherSheet(),
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      );

  void openMenu() => Get.bottomSheet(
        const ProfileMenuSheet(),
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      );

  void editProfile() => Get.toNamed(AppRoutes.editProfile);

  void shareProfile() {
    Get.put(ShareController(profile: user));
    Get.bottomSheet(
      const ShareSheet(),
      isScrollControlled: true,
      backgroundColor: AppColors.white,
    ).whenComplete(() => Get.delete<ShareController>());
  }
}
