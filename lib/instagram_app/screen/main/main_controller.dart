import 'package:get/get.dart';

/// Controls the bottom navigation tab selection on [MainScreen].
class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// Tab indices that map to a real page in the IndexedStack.
  /// Index 2 (the center "add" button) opens a sheet instead of a page.
  void changePage(int index) => currentIndex.value = index;
}
