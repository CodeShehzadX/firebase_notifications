import 'package:get/get.dart';

import '../../models/notification_model.dart';
import '../../services/dummy_data_service.dart';

class NotificationController extends GetxController {
  final DummyDataService _data = Get.find<DummyDataService>();

  RxList<NotificationModel> get notifications => _data.notifications;

  List<NotificationModel> sectionItems(NotificationSection section) =>
      notifications.where((n) => n.section == section).toList();

  void toggleFollow(NotificationModel item) {
    item.isFollowing = !item.isFollowing;
    item.user.isFollowing = item.isFollowing;
    notifications.refresh();
  }
}
