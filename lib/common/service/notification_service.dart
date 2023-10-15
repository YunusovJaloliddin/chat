import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _onBackgroundNotification(RemoteMessage message) async {
  print(
      "Handing a background message: ${message.messageId} / ${message.notification?.body} / ${message.notification?.title}");
}

class NotificationService {
  String? fcmTocen;

  static final _LNC = FlutterLocalNotificationsPlugin();
  static final _messaging = FirebaseMessaging.instance;

  Future<void> requestPermisson() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> generateToken() async {
    await _messaging.getToken().then(
      (value) => fcmTocen = value,
      onError: (Object? e, StackTrace stack) async {
        await generateToken();
      },
    );

    print("---------------------------------------------");
    print(fcmTocen);
    print("---------------------------------------------");
  }

  Future<void> notificationSettings() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          print("FCM notification settings - $payload"),
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _LNC.initialize(settings,
        onDidReceiveNotificationResponse: (details) {
      print('On notification clicked (id): ${details.id}');
      print('On notification clicked (actionId): ${details.actionId}');
      print('On notification clicked (input): ${details.input}');
      print(
          'On notification clicked (notificationResponseType): ${details.notificationResponseType}');
      print('On notification clicked (payload): ${details.payload}');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      print("--------onMessage-----------");
      print(
        "onMessage : ${message.notification?.title} | ${message.notification?.body} | ${message.data}",
      );
      await _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print("--------------onMessageOpenedApp--------------");
      print(
        "onMessage: ${message.notification?.title} | ${message.notification?.body} | ${message.data}",
      );

      await _showNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_onBackgroundNotification);
  }
}

Future<void> _showNotification(RemoteMessage message) async {
  if (message.notification != null) {
    const androidPlatformSpecifics = AndroidNotificationDetails(
      "firebase_chats_app_channel_1",
      "firebase_chats_app_channel",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      fullScreenIntent: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    final id = Random().nextInt((pow(2, 31) - 1).toInt());

    await NotificationService._LNC.show(
      id,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}
