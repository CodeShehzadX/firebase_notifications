import 'package:flutter/material.dart';

import '../instagram_app/instagram_app.dart';

/// Global navigator key retained from the previous Firebase messaging demo
/// (still referenced by lib/notificartion_service.dart).
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const InstagramApp());
}
