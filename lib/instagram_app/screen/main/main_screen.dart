import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/svg_icon.dart';
import '../../widgets/user_avatar.dart';
import '../home/home_controller.dart';
import '../home/home_screen.dart';
import '../message/message_screen.dart';
import '../profile/profile_screen.dart';
import '../reels/reels_screen.dart';
import '../search/search_screen.dart';
import 'main_controller.dart';

/// Root scaffold that hosts the bottom navigation and its tab pages.
///
/// Tab order: Home, Reels, Messages, Search, Profile.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _pages = [
    HomeScreen(), // 0
    ReelsScreen(), // 1
    MessageScreen(), // 2
    SearchScreen(), // 3
    ProfileScreen(), // 4
  ];

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find<MainController>();

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: _bottomBar(controller),
      ),
    );
  }

  Widget _bottomBar(MainController controller) {
    final int current = controller.currentIndex.value;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _svgItem(controller, 0, AppAssets.home, AppAssets.homeFill,
                  current),
              _reelsItem(controller, 1, current),
              _svgItem(controller, 2, AppAssets.message, AppAssets.message,
                  current),
              _svgItem(controller, 3, AppAssets.search, AppAssets.search,
                  current),
              _profileItem(controller, 4, current),
            ],
          ),
        ),
      ),
    );
  }

  Widget _svgItem(
    MainController controller,
    int index,
    String icon,
    String activeIcon,
    int current,
  ) {
    final bool selected = current == index;
    return IconButton(
      onPressed: () => controller.changePage(index),
      icon: SvgIcon(selected ? activeIcon : icon, size: 27),
    );
  }

  Widget _reelsItem(MainController controller, int index, int current) {
    final bool selected = current == index;
    return IconButton(
      onPressed: () => controller.changePage(index),
      icon: Icon(
        selected ? Icons.video_collection : Icons.video_collection_outlined,
        size: 27,
        color: AppColors.black,
      ),
    );
  }

  Widget _profileItem(MainController controller, int index, int current) {
    final bool selected = current == index;
    final HomeController home = Get.find<HomeController>();
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.black : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: UserAvatar(imageUrl: home.me.avatarUrl, size: 27),
      ),
    );
  }
}
