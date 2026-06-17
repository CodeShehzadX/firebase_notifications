import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_application_2_test/firebase/second_screen.dart';
import 'package:flutter_application_2_test/firebase/main.dart'; 

class NotificartionService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> RequestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else {
      print("user denied permission");
    }
  }

  Future<void> initLocalNotifications() async {
    var androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if(response.payload=='msg')
       { navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const SecondScreen()),
      );}
      },
    );

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',  
      'High Importance Channel',
      importance: Importance.max,
       playSound: true,
    enableVibration: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<  
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void firebaseInit(BuildContext context) {
      print("FIREBASE INIT CALLED");  

    FirebaseMessaging.onMessage.listen((message) {
      if(kDebugMode){
          print("MESSAGE RECEIVED IN FLUTTER");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print(message.data["type"]);
      print(message.data["id"]);
      }
          showNotification(message);
    }
    );
  }
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'high_importance_channel',  
      'High Importance Channel',
      channelDescription: "Your Channel Description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "tick",
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
      payload:message.data["type"],
    );
  }
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token ?? "No token received";
  }
  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((String newToken) {
      if (kDebugMode) {
        print('FCM token refreshed: $newToken');
      }
    });
  }
Future<void> setupInteractMessage(BuildContext context) async {
    print("SETUP INTERACT CALLED");
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
        print("Initial message: $initialMessage");
  if (initialMessage != null) {
   Future.delayed(const Duration(seconds: 1), () {
      handleMessage(context, initialMessage);
    });
  }
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print("onMessageOpenedApp FIRED");
    print("data: ${event.data}");
    handleMessage(context, event);
  });
}
  void handleMessage(BuildContext context, RemoteMessage message) {
    print("HANDLE MESSAGE CALLED");
  print("type: ${message.data["type"]}");
if (message.data["type"]== 'msg'){
      print("NAVIGATING TO SECOND SCREEN");
    navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const SecondScreen()),
      );
}else{
      print("TYPE DID NOT MATCH - got: ${message.data["type"]}");
}
  }
}