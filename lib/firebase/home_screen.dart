import 'package:flutter/material.dart';
import 'package:flutter_application_2_test/firebase/notificartion_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificartionService notificartionService = NotificartionService();
  @override
void initState() {
  super.initState();
  _init();
}

  Future<void> _init() async {
  await notificartionService.RequestNotificationPermission();
  print("STEP 1 DONE");
  await notificartionService.initLocalNotifications();
  print("STEP 2 DONE");
  if(!mounted) return;
  notificartionService.firebaseInit(context);
  print("STEP 3 DONE");
  notificartionService.setupInteractMessage(context);
  print("STEP 4 DONE");
  String token = await notificartionService.getDeviceToken();
  print("Device token: $token");
  notificartionService.isTokenRefresh();
  print("STEP 5 DONE");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notif")
        ),
      );
    
  }
}